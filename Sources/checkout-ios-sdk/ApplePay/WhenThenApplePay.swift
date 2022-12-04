//
//  File.swift
//  
//
//  Created by Elikem Savie on 22/11/2022.
//

import Foundation
import PassKit

public protocol WhenThenApplePayDelegate {

     func applePayContext(
        _ sender: WhenThenApplePay,
        didSelect shippingMethod: PKShippingMethod,
        handler: @escaping (_ update: PKPaymentRequestShippingMethodUpdate) -> Void
    )

    func applePayContext(
        _ sender: WhenThenApplePay,
        didCompleteWith status: WhenThenApplePay.PaymentStatus,
        error: Error?
    )

//    func applePayContext(
//        _ sender: WhenThenApplePay,
//        didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod,
//        paymentInformation: PKPayment,
//        completion: @escaping STPIntentClientSecretCompletionBlock
//    )

}

public class WhenThenApplePay: NSObject {

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
    var delegate: WhenThenApplePayDelegate?
    var paymentState: PaymentState = .notStarted
    var orderId: String?
    var flowId: String?
    var amount: Double
    var currencyCode: String

    private var didCancelOrTimeoutWhilePending = false

    public init(
        withMerchantIdentifier merchantIdentifier: String,
        amount: Double,
        country countryCode: String,
        currency currencyCode: String,
        orderId: String?,
        flowId: String?,
        delegate: WhenThenApplePayDelegate
    ) {
        self.orderId = orderId
        self.flowId = flowId
        self.amount = amount
        self.currencyCode = currencyCode
        super.init()
        let paymentRequest = makePaymentRequest(
            withMerchantIdentifier: merchantIdentifier,
            amount: amount,
            country: countryCode,
            currency: currencyCode
        )

        authorizationController = PKPaymentAuthorizationViewController(
            paymentRequest: paymentRequest
        )

//        if PKPaymentAuthorizationViewController.canMakePayments() {
//            print("🇬🇭🇬🇭🇬🇭🇬🇭🇬🇭🇬🇭")
//        } else
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.amex, .masterCard, .visa, .discover]) {
            print("😂😂😂😂😂😂")
        } else {
            print("❌ Cant make payment on this device")
        }

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

extension WhenThenApplePay: PKPaymentAuthorizationViewControllerDelegate {
    
    public func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
        print("✅ Authorisinggg")

    }
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("✅ Authorisation finished")
    }
    
    public func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult
        ) -> Void) {
        
        _completePayment(with: payment) { status, error in
//            let result = PKPaymentAuthorizationResult(status: status, errors: [error])
            
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }
    }

    func _completePayment(
        with payment: PKPayment,
        completion: @escaping (PKPaymentAuthorizationStatus, Error?) -> Void
    ) {
        
        let handleFinalState: ((PaymentState, Error?) -> Void) = { state, error in
            switch state {
            case .error:
                self.paymentState = .error
                if self.didCancelOrTimeoutWhilePending {
                    self.authorizationController?.dismiss(animated: true) {
                        DispatchQueue.main.async {
                            self.delegate?.applePayContext(self, didCompleteWith: .error, error: error)
                            self.delegate = nil
                            self.authorizationController = nil
                        }
                    }
                } else {
                    completion(PKPaymentAuthorizationStatus.failure, error)
                }
                return
            case .success:
                self.paymentState = .success
                if self.didCancelOrTimeoutWhilePending {
                    
                    self.authorizationController?.dismiss(animated: true) {
                        DispatchQueue.main.async {
                            self.delegate?.applePayContext(self, didCompleteWith: .success, error: nil)
                        }
                    }
                } else {
                    completion(PKPaymentAuthorizationStatus.success, nil)
                }
                return
            case .pending, .notStarted:
                return
            }
        }
        
        let token = payment.token.paymentData.base64EncodedString().fromBase64()
        print("😀 apple pay token", token)

        let authData = AuthorisedPayment(
            orderId: self.orderId,
            flowId: self.flowId,
            amount: String(amount),
            currencyCode: self.currencyCode,
            paymentMethod: PaymentDtoInput(
                type: .applePay,
                token: token
            )
        )
        
        Task {
            do {
                let authpayment = try await WhenThenSDK.authorizePayment(apikey: WhenThenSDK.clientID, paymentData: authData)
                handleFinalState(.success, nil)
            } catch {
                handleFinalState(.error, error)
            }
        }

        
        // 1. Create PaymentMethod
        //        StripeAPI.PaymentMethod.create(apiClient: apiClient, payment: payment) { result in
        //            guard let paymentMethod = try? result.get(), self.authorizationController != nil else {
        //                if case .failure(let error) = result {
        //                    handleFinalState(.error, error)
        //                } else {
        //                    handleFinalState(.error, nil)
        //                }
        //                return
        //            }
        //
        //            let paymentMethodCompletion : STPIntentClientSecretCompletionBlock = {
        //                clientSecret, intentCreationError in
        //                    guard let clientSecret = clientSecret, intentCreationError == nil,
        //                        self.authorizationController != nil
        //                    else {
        //                        handleFinalState(.error, intentCreationError)
        //                        return
        //                    }
        //
        //                if StripeAPI.SetupIntentConfirmParams.isClientSecretValid(clientSecret) {
        //                        // 3a. Retrieve the SetupIntent and see if we need to confirm it client-side
        //                        StripeAPI.SetupIntent.get(apiClient: self.apiClient, clientSecret: clientSecret) {
        //                            result in
        //                            guard let setupIntent = try? result.get(), self.authorizationController != nil else {
        //                                if case .failure(let error) = result {
        //                                    handleFinalState(.error, error)
        //                                } else {
        //                                    handleFinalState(.error, nil)
        //                                }
        //                                return
        //                            }
        //
        //                            switch setupIntent.status {
        //                            case .requiresConfirmation, .requiresAction, .requiresPaymentMethod:
        //                                // 4a. Confirm the SetupIntent
        //                                self.paymentState = .pending  // After this point, we can't cancel
        //                                var confirmParams = StripeAPI.SetupIntentConfirmParams(
        //                                    clientSecret: clientSecret)
        //                                confirmParams.paymentMethod = paymentMethod.id
        //                                confirmParams.useStripeSdk = true
        //
        //                                StripeAPI.SetupIntent.confirm(apiClient: self.apiClient, params: confirmParams) {
        //                                    result in
        //                                    guard let setupIntent = try? result.get(), self.authorizationController != nil,
        //                                          setupIntent.status == .succeeded
        //                                    else {
        //                                        if case .failure(let error) = result {
        //                                            handleFinalState(.error, error)
        //                                        } else {
        //                                            handleFinalState(.error, nil)
        //                                        }
        //                                        return
        //                                    }
        //
        //                                    handleFinalState(.success, nil)
        //                                }
        //                            case .succeeded:
        //                                handleFinalState(.success, nil)
        //                            case .canceled, .processing, .unknown, .unparsable, .none:
        //                                handleFinalState(
        //                                    .error,
        //                                    Self.makeUnknownError(
        //                                        message:
        //                                            "The SetupIntent is in an unexpected state: \(setupIntent.status!)"
        //                                    ))
        //                            }
        //                        }
        //                    } else {
        //                        let paymentIntentClientSecret = clientSecret
        //                        // 3b. Retrieve the PaymentIntent and see if we need to confirm it client-side
        //                        StripeAPI.PaymentIntent.get(
        //                            apiClient: self.apiClient,
        //                            clientSecret: paymentIntentClientSecret
        //                        ) { result in
        //                            guard let paymentIntent = try? result.get(), self.authorizationController != nil
        //                            else {
        //                                if case .failure(let error) = result {
        //                                    handleFinalState(.error, error)
        //                                } else {
        //                                    handleFinalState(.error, nil)
        //                                }
        //                                return
        //                            }
        //
        //                            if paymentIntent.confirmationMethod == .automatic
        //                                && (paymentIntent.status == .requiresPaymentMethod
        //                                    || paymentIntent.status == .requiresConfirmation)
        //                            {
        //                                // 4b. Confirm the PaymentIntent
        //
        //                                var paymentIntentParams = StripeAPI.PaymentIntentParams(
        //                                    clientSecret: paymentIntentClientSecret)
        //                                paymentIntentParams.paymentMethod = paymentMethod.id
        //                                paymentIntentParams.useStripeSdk = true
        //                                // If a merchant attaches shipping to the PI on their server, the /confirm endpoint will error if we update shipping with a “requires secret key” error message.
        //                                // To accommodate this, don't attach if our shipping is the same as the PI's shipping
        //                                if paymentIntent.shipping != self._shippingDetails(from: payment) {
        //                                    paymentIntentParams.shipping = self._shippingDetails(from: payment)
        //                                }
        //
        //                                self.paymentState = .pending  // After this point, we can't cancel
        //
        //                                // We don't use PaymentHandler because we can't handle next actions as-is - we'd need to dismiss the Apple Pay VC.
        //                                StripeAPI.PaymentIntent.confirm(apiClient: self.apiClient, params: paymentIntentParams) {
        //                                    result in
        //                                    guard let postConfirmPI = try? result.get(),
        //                                          postConfirmPI.status == .succeeded || postConfirmPI.status == .requiresCapture
        //                                    else {
        //                                        if case .failure(let error) = result {
        //                                            handleFinalState(.error, error)
        //                                        } else {
        //                                            handleFinalState(.error, nil)
        //                                        }
        //                                        return
        //                                    }
        //                                    handleFinalState(.success, nil)
        //                                }
        //                            } else if paymentIntent.status == .succeeded
        //                                || paymentIntent.status == .requiresCapture
        //                            {
        //                                handleFinalState(.success, nil)
        //                            } else {
        //                                let unknownError = Self.makeUnknownError(
        //                                    message:
        //                                        "The PaymentIntent is in an unexpected state. If you pass confirmation_method = manual when creating the PaymentIntent, also pass confirm = true.  If server-side confirmation fails, double check you are passing the error back to the client."
        //                                )
        //                                handleFinalState(.error, unknownError)
        //                            }
        //                        }
        //                    }
        //                }
        //            // 2. Fetch PaymentIntent/SetupIntent client secret from delegate
        //            let legacyDelegateSelector = NSSelectorFromString("applePayContext:didCreatePaymentMethod:paymentInformation:completion:")
        //            if let delegate = self.delegate {
        //                if let delegate = delegate as? ApplePayContextDelegate {
        //                     delegate.applePayContext(
        //                         self, didCreatePaymentMethod: paymentMethod, paymentInformation: payment, completion: paymentMethodCompletion)
        //            } else if delegate.responds(to: legacyDelegateSelector),
        //               let helperClass = NSClassFromString("STPApplePayContextLegacyHelper") {
        //                    let legacyStorage = _stpinternal_ApplePayContextDidCreatePaymentMethodStorage(delegate: delegate, context: self, paymentMethod: paymentMethod, paymentInformation: payment, completion: paymentMethodCompletion)
        //                    helperClass.performDidCreatePaymentMethod(legacyStorage)
        //               } else {
        //                assertionFailure("An STPApplePayContext's delegate must conform to ApplePayContextDelegate or STPApplePayContextDelegate.")
        //               }
        //            }
        //        }
    }
}
