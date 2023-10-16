//
//  PaymentFormController.swift
//  
//
//  Created by Elikem Savie on 31/07/2023.
//

import UIKit
import MangopaySdkAPI
import PassKit

class PaymentFormController: UIViewController {

    var formView: PaymentFormView!

    var paymentFormStyle: PaymentFormStyle
    var callback: CallBack
    var paymentMethodConfig: PaymentMethodConfig
    var handlePaymentFlow: Bool
    let paymentHandler = MGPApplePayHandler()

    public init(
        cardConfig: CardConfig? = nil,
        paymentMethodConfig: PaymentMethodConfig,
        handlePaymentFlow: Bool,
        branding: PaymentFormStyle?,
        callback: CallBack
    ) {

        self.paymentFormStyle = branding ?? PaymentFormStyle()
        self.callback = callback
        self.paymentMethodConfig = paymentMethodConfig
        self.handlePaymentFlow = handlePaymentFlow

        formView = PaymentFormView(
            client: MangopayClient(
                clientId: MangopayCoreiOS.clientId,
                environment: MangopayCoreiOS.environment)
            ,
            paymentMethodConfig: paymentMethodConfig,
            handlePaymentFlow: handlePaymentFlow,
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
            guard let applePayConfig = self.paymentMethodConfig.applePayConfig else { return }
            self.paymentHandler.setData(payRequest: applePayConfig.toPaymentRequest)
            self.paymentHandler.startPayment(delegate: self) { (success) in
                if success {
                    print("✅ Confirmation")
                }
            }
        }

        formView.onClosedTapped = {
            self.navigationController?.dismiss(animated: true, completion: {
                self.callback.onSheetDismissed?()
            })
        }
    }

    @objc func closeTapped() {
        self.dismiss(animated: true) {
            self.callback.onSheetDismissed?()
        }

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
}

extension PaymentFormController: MGPApplePayHandlerDelegate {

    func applePayContext(didSelect shippingMethod: PKShippingMethod, handler: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        
    }

    func applePayContext(didCompleteWith status: MangoPayApplePay.PaymentStatus, error: Error?) {
        switch status {
        case .success(let token):
            print("🤣 MangoPayApplePay.token", token)
        case .error:
            print("❌ MangoPayApplePay.error")
        case .userCancellation: break
            
        }
    }
    
    
}
