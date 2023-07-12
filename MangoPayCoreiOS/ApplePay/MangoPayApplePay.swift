//
//  File.swift
//  
//
//  Created by Elikem Savie on 22/11/2022.
//

import Foundation
import PassKit
import MangoPaySdkAPI

public protocol MangoPayApplePayDelegate {

     func applePayContext(
        _ sender: MangoPayApplePay,
        didSelect shippingMethod: PKShippingMethod,
        handler: @escaping (_ update: PKPaymentRequestShippingMethodUpdate) -> Void
    )

    func applePayContext(
        _ sender: MangoPayApplePay,
        didCompleteWith status: MangoPayApplePay.PaymentStatus,
        error: Error?
    )

//    func applePayContext(
//        _ sender: WhenThenApplePay,
//        didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod,
//        paymentInformation: PKPayment,
//        completion: @escaping STPIntentClientSecretCompletionBlock
//    )

}

public class MangoPayApplePay: NSObject {

     public enum PaymentStatus {
        case success
        case error
        case userCancellation
    }

    public enum PaymentState {
        case notStarted
        case pending
        case error
        case success
    }

    var authorizationController: PKPaymentAuthorizationViewController?
    var delegate: MangoPayApplePayDelegate?
    var paymentState: PaymentState = .notStarted
    var orderId: String?
    var flowId: String?
    var applePayMerchantId: String?
    var amount: Double
    var currencyCode: String
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .discover,
        .masterCard,
        .visa
    ]
    
     var paymentRequest: PKPaymentRequest!

    private var didCancelOrTimeoutWhilePending = false

    public init(
        withMerchantIdentifier merchantIdentifier: String,
        amount: Double,
        country countryCode: String,
        currency currencyCode: String,
        orderId: String?,
        flowId: String?,
        delegate: MangoPayApplePayDelegate
    ) {
        self.orderId = orderId
        self.flowId = flowId
        self.amount = amount
        self.currencyCode = currencyCode
        self.applePayMerchantId = merchantIdentifier
        super.init()
        let paymentRequest = makePaymentRequest(
            withMerchantIdentifier: merchantIdentifier,
            amount: amount,
            country: countryCode,
            currency: currencyCode
        )
        self.paymentRequest = paymentRequest

        authorizationController = PKPaymentAuthorizationViewController(
            paymentRequest: paymentRequest
        )

        self.delegate = delegate
        authorizationController?.delegate = self
    }

    public func presentApplePay(in controller: UIViewController) {
        guard let applePayController = authorizationController else { return }
        controller.present(applePayController, animated: true, completion: nil)
    }

    private func makePaymentRequest(
        withMerchantIdentifier merchantIdentifier: String,
        amount: Double,
        country countryCode: String,
        currency currencyCode: String
    ) -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantIdentifier
        paymentRequest.supportedNetworks = [.amex, .masterCard, .visa, .discover]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = countryCode.uppercased()
        paymentRequest.currencyCode = currencyCode.uppercased()
        paymentRequest.requiredBillingContactFields = Set([.postalAddress])
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(
                label: "Item",
                amount: NSDecimalNumber(value: amount))
        ]

        return paymentRequest
    }
}

extension MangoPayApplePay: PKPaymentAuthorizationViewControllerDelegate {
    
    public func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
        print("✅ Authorisinggg")

    }
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("✅ Authorisation finished")
    }
    
    public func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        // Perform basic validation on the provided contact information.
        let errors = [Error]()
        
        var token = payment.token.paymentData
        print("token,", token)
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }

    func _completePayment(
        with payment: PKPayment,
        completion: @escaping (PKPaymentAuthorizationStatus, Error?) -> Void
    ) {
        
        let handleFinalState: ((PaymentState, Error?) -> Void) = { state, error in
            switch state {
            case .error:
                self.paymentState = .error
                DispatchQueue.main.async {
                    
                    self.authorizationController?.dismiss(animated: true) {
                        self.delegate?.applePayContext(self, didCompleteWith: .error, error: error)
                        self.delegate = nil
                        self.authorizationController = nil
                        completion(PKPaymentAuthorizationStatus.failure, error)
                    }
                }
                
                return
            case .success:
                self.paymentState = .success
                DispatchQueue.main.async {
                    self.authorizationController?.dismiss(animated: true) {
                        self.delegate?.applePayContext(self, didCompleteWith: .success, error: nil)
                        completion(PKPaymentAuthorizationStatus.success, nil)
                    }
                }
                
                return
            case .pending, .notStarted:
                return
            }
        }
        
        var token = payment.token.paymentData.base64EncodedString().fromBase64()
        token = "{ \"paymentData\": \(token) }" //wrap token in paymentData object
        
        print("😀 apple pay token", token)
        
        let authData = AuthorisedPayment(
            orderId: self.orderId,
            flowId: self.flowId,
            amount: String(amount),
            currencyCode: self.currencyCode,
            paymentMethod: PaymentDtoInput(
                type: .applePay,
                walletToken: token
            )
        )
        
        Task {
            do {
                let authpayment = try await MangoPaySDK.authorizePayment(apikey: MangoPaySDK.apiKey, paymentData: authData)
                handleFinalState(.success, nil)
            } catch {
                handleFinalState(.error, error)
            }
        }
    }
}
