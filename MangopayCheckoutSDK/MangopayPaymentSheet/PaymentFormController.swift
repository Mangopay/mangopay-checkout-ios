//
//  PaymentFormController.swift
//  
//
//  Created by Elikem Savie on 31/07/2023.
//

import UIKit
import PassKit
import NethoneSDK

class PaymentFormController: UIViewController {

    var formView: PaymentFormView!

    var paymentFormStyle: PaymentFormStyle
    var callback: CallBack
    var paymentMethodOptions: PaymentMethodOptions
    let paymentHandler = MGPApplePayHandler()
    var navVC: UINavigationController?
    
    public init(
        cardConfig: CardConfig? = nil,
        paymentMethodOptions: PaymentMethodOptions,
        branding: PaymentFormStyle?,
        callback: CallBack
    ) {

        self.paymentFormStyle = branding ?? PaymentFormStyle()
        self.callback = callback
        self.paymentMethodOptions = paymentMethodOptions

        formView = PaymentFormView(
            client: MangopayClient(
                clientId: MangopayCheckoutSDK.clientId,
                environment: MangopayCheckoutSDK.environment)
            ,
            paymentMethodOptions: paymentMethodOptions,
            branding: branding,
            callback: callback
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = formView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        self.navVC = self.navigationController
        SentryManager.log(name: .PAYMENT_METHODS_RENDERED)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setNavigation()
    }

    func setNavigation() {
        formView.navView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }

    func setupObservers() {
        formView.onApplePayTapped = {
            guard let applePayConfig = self.paymentMethodOptions.applePayOptions else { return }
            self.paymentHandler.setData(payRequest: applePayConfig.toPaymentRequest)
            self.paymentHandler.startPayment(delegate: applePayConfig.delegate) { (success) in
                if success {
                }
            }
        }
        
        formView.onClosedTapped = {
            self.navigationController?.dismiss(animated: true, completion: {

                self.callback.onCancel?()
                NethoneManager.shared.cancelNethoneAttemptIfAny()
            })
        }
        
        formView.onAPMTapped = { apmInfo in
            if let _urlStr = apmInfo.secureModeRedirectURL, let url = URL(string: _urlStr) {
                let urlController = MGPWebViewController(
                    url: url,
                    nethoneAttemptReference: NTHNethone.attemptReference(),
                    onComplete: { status in

                        self.callback.onPaymentCompleted?(nil, status)
                        switch status.status {
                        case .SUCCEEDED:
                            SentryManager.log(name: .PAYMENT_COMPLETED)
                        case .FAILED:
                            SentryManager.log(name: .PAYMENT_ERRORED)

                            NethoneManager.shared.performFinalizeAttempt { res, attemptRef in
                                self.callback.onPaymentCompleted?(nil, status)
                            }
                        case .CANCELLED: break
                            
                        }
                    },
                    onError: { error in
                        self.callback.onError?(MGPError._3dsError(additionalInfo: error?.localizedDescription))
                        SentryManager.log(name: .PAYMENT_FAILED)
                        SentryManager.log(error: MGPError._3dsError(additionalInfo: error?.localizedDescription))
                    }
                )
                
                self.navigationController?.pushViewController(urlController, animated: true)
            }
        }

        formView.viewModel.onCreatePaymentComplete = { paymentObj in
            guard let payObj = paymentObj else {
                return
            }

            self.launch3DSIfPossible(paymentObj: payObj)
        }
    }

    @objc func doneAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func closeTapped() {
        self.displayAlert(
            with: "Are you sure you want to leave",
            message: "",
            preferredStyle: .alert,
            actions: [
                UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                    self.dismiss(animated: true) {
                        self.callback.onCancel?()
                        NethoneManager.shared.cancelNethoneAttemptIfAny()
                    }
                }),
                UIAlertAction(title: "No", style: .default)
            ]
            
        )
    }

    func clearForm() {
        formView.clearForm()
    }

    func isFormValid() -> Bool {
        return formView.isFormValid
    }

    func manuallyValidateForms() {
        formView.manuallyValidateForms()
    }

    private func launch3DSIfPossible(
        paymentObj: Payable? = nil
    ) {
        SentryManager.log(name: .THREE_AUTH_REQ)

        MGPPaymentSheet().launch3DSIfPossible(payData: paymentObj, presentIn: self) { result in
            switch result.status {
            case .SUCCEEDED:
                SentryManager.log(name: .THREE_AUTH_COMPLETED)
            case .FAILED:
                SentryManager.log(name: .THREE_AUTH_FAILED)
            default: break
            }
            self.callback.onPaymentCompleted?(result.id, result)
        } on3DSLauch: { _3dsVC in
            DispatchQueue.main.async {
                self.navVC?.pushViewController(_3dsVC, animated: true)
            }
        } on3DSFailure: { error in
            DispatchQueue.main.async {
                self.showAlert(with: "", title: "3DS challenge failed")
            }
        } on3DSError: { error in
            print("error", error)
            SentryManager.log(name: .THREE_AUTH_FAILED)
            switch error {
            case ._3dsNotRqd:
                self.callback.onPaymentCompleted?(nil, _3DSResult(type: .cardDirect, status: .SUCCEEDED, id: paymentObj?.cardID ?? ""))
            default: break
            }
            SentryManager.log(error: error)
        }
    }
}

