//
//  PaymentFormController.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import UIKit
import Combine
import PassKit

public class PaymentFormController: UIViewController {

    var formView: PaymentFormView!
    var cancelables = Set<AnyCancellable>()
    var cardConfig: CardConfig?
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .discover,
        .masterCard,
        .visa
    ]
    
    private var paymentRequest : PKPaymentRequest = {
    
        // Create a payment request.
        let paymentRequest = PKPaymentRequest()
        
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = supportedNetworks
        paymentRequest.shippingType = .delivery
        paymentRequest.merchantIdentifier = "merchant.co.whenthen.applepay"
        paymentRequest.supportedNetworks = [.amex, .masterCard, .visa, .discover]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.requiredBillingContactFields = Set([.postalAddress])
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(
                label: "Item",
                amount: NSDecimalNumber(value: 20))
        ]
        
        if #available(iOS 15.0, *) {
         #if !os(watchOS)
            paymentRequest.supportsCouponCode = true
         #endif
        } else {
            // Fallback on earlier versions
        }
                
        return paymentRequest;
    }()

    public init(
        cardConfig: CardConfig? = nil,
        dropInOptions: DropInOptions? = nil,
        elementOptions: ElementsOptions? = nil
    ) {
        if let dropInOptions = dropInOptions {
            formView = PaymentFormView(paymentFormStyle: dropInOptions.style, formType: .dropIn)
        } else if let elementOptions = elementOptions {
            formView = PaymentFormView(paymentFormStyle: elementOptions.style, formType: .element)
        } else {
            formView = PaymentFormView(paymentFormStyle: PaymentFormStyle(), formType: .dropIn)
        }

        super.init(nibName: nil, bundle: nil)
        formView.viewModel.dropInDelegate = dropInOptions?.delegate
        formView.viewModel.dropInData = dropInOptions
        formView.viewModel.elementDelegate = elementOptions?.delegate
        self.cardConfig = cardConfig
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        formView.setCards(cards: self.cardConfig)
    }

    public override func loadView() {
        view = formView
    }

    func setupObservers() {
        formView.viewModel.tokenObserver.sink { tokenised in
            self.showAlert(with: tokenised.token, title: "Tokenised Card")
        }.store(in: &cancelables)

        formView.viewModel.statusObserver.sink { status in
            DispatchQueue.main.async {
                let text = self.formView.statusLabel.text ?? ""
                self.formView.statusLabel.text = text.appending("\n \n \(status) \n ==========")
            }
        }.store(in: &cancelables)

        formView.viewModel.trigger3DSObserver.sink { url in
            DispatchQueue.main.async {
                self.routeTo3DS(with: url)
            }
        }.store(in: &cancelables)
        
        formView.onApplePayTapped = {
//            let applePay = WhenThenApplePay(
//                withMerchantIdentifier: "merchant.co.whenthen.applepay",
//                amount: 200,
//                country: "US",
//                currency: "USD",
//                orderId: "5114e019-9316-4498-a16d-4343fda403eb",
//                flowId: "c23700cf-25a9-4b80-8aa6-3e3169f6d896",
//                delegate: self
//            )
//            applePay.presentApplePay(in: self)
            let paymentController = PKPaymentAuthorizationViewController(paymentRequest: self.paymentRequest)
            if paymentController != nil {
                paymentController!.delegate = self
                self.present(paymentController!, animated: true, completion: nil)
            }
        }

        Task {
            let items = try await WhenThenClient.shared.fetchCards(with: nil)
            
            let cards = items.compactMap({$0.brandType})
            self.formView.setUsersCards(cards)
            
            formView.onRightButtonTappedAction = {
                CustomerCardListController.showDatePicker(with: self, cardLists: items) { cardType in
                    self.formView.cardNumberField.text = cardType.number
                }
            }

        }

    }

    func routeTo3DS(with url: URL) {
        let vc = ThreeDSController(successUrl: url, failUrl: nil)
        vc.authUrl = url
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func showAlert(with cardToken: String, title: String) {
        let alert = UIAlertController(
            title: title,
            message: cardToken,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func applePay(_ sender: UIButton) {
        // Display the payment sheet.
        let paymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if paymentController != nil {
            paymentController!.delegate = self
            present(paymentController!, animated: true, completion: nil)
        }
    }
}

extension PaymentFormController: ThreeDSControllerDelegate {

    public func onSuccess3D(paymentId: String) {
        let text = self.formView.statusLabel.text ?? ""
        self.formView.statusLabel.text = text.appending("\n \n 3DS SUCESSFULL \n ==========")
        
        Task {
            guard let payment = await self.formView.viewModel.getPayment(with: paymentId) else { return }

            let text = self.formView.statusLabel.text ?? ""
            self.formView.statusLabel.text = text.appending("\n \n paymentId \(payment.id) \n ==========")

            self.formView.viewModel.dropInDelegate?.onPaymentCompleted(
                sender: self.formView.viewModel,
                payment: payment
            )
        }
    }
    
    public func onFailure3D() {
        let text = self.formView.statusLabel.text ?? ""
        self.formView.statusLabel.text = text.appending("\n \n 3DS FAILED \n ==========")

    }
    
    
}

extension PaymentFormController: WhenThenApplePayDelegate {

    public func applePayContext(
        _ sender: WhenThenApplePay,
        didSelect shippingMethod: PKShippingMethod,
        handler: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void
    ) {
        
    }

    public func applePayContext(
        _ sender: WhenThenApplePay,
        didCompleteWith status: WhenThenApplePay.PaymentStatus,
        error: Error?
    ) {
        print("😅 Did complete ", status)
    }
    
    
}

extension PaymentFormController: PKPaymentAuthorizationViewControllerDelegate {
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        // Perform basic validation on the provided contact information.
        let errors = [Error]()
        
        var token = payment.token.paymentData
        print("token,", token)
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        
    }
}
