//
//  File.swift
//  
//
//  Created by Elikem Savie on 22/11/2022.
//

import Foundation
import PassKit

public typealias PaymentCompletionHandler = (Bool) -> Void

public protocol MGPApplePayHandlerDelegate {

    func applePayContext(
       didSelect shippingMethod: PKShippingMethod,
       handler: @escaping (_ update: PKPaymentRequestShippingMethodUpdate) -> Void
   )

   func applePayContext(
       didCompleteWith status: MGPApplePay.PaymentStatus,
       error: Error?
   )

}

public class MGPApplePay: NSObject {

    public enum PaymentStatus {
       case success(String)
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
//   var delegate: MangoPayApplePayDelegate?
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
   var completionHandler: PaymentCompletionHandler!


   public init(config: MGPApplePayOptions) {
       self.amount = config.amount
       self.currencyCode = config.currencyCode
       self.applePayMerchantId = config.merchantIdentifier
       super.init()
       self.paymentRequest = config.toPaymentRequest

       authorizationController = PKPaymentAuthorizationViewController(
           paymentRequest: paymentRequest
       )
//
//       self.delegate = config.delegate
//       authorizationController?.delegate = self
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

extension MGPApplePay: PKPaymentAuthorizationViewControllerDelegate {
   
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
//       let errors = [Error]()
       
//       var token = payment.token.paymentData
//       print("token,", token)
//       let tokenStr = payment.token.paymentData.base64EncodedString().fromBase64()
//
////       _completePayment(with: payment, completion: completion)
//
//        self. v?.applePayContext(self, didCompleteWith: .success(tokenStr), error: nil)
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
           
//           var errors = [Error]()
//             var status = PKPaymentAuthorizationStatus.success
//             if payment.shippingContact?.postalAddress?.isoCountryCode != "US" {
//                 let pickupError = PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "Sample App only available in the United States")
//                 let countryError = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressCountryKey, localizedDescription: "Invalid country")
//                 errors.append(pickupError)
//                 errors.append(countryError)
//                 status = .failure
//             } else {
//                 // Send the payment token to your server or payment provider to process here.
//                 // Once processed, return an appropriate status in the completion handler (success, failure, and so on).
//             }
//
////             self.paymentStatus = status
//             completion(PKPaymentAuthorizationResult(status: status, errors: errors))

//           print("❌ ERRORS", errors)
   }

   func _completePayment(
       with payment: PKPayment,
       completion: @escaping (PKPaymentAuthorizationResult) -> Void
   ) {
       
       let _: ((PaymentState, Error?) -> Void) = { state, error in
           switch state {
           case .error:
               self.paymentState = .error
               DispatchQueue.main.async {
                   self.authorizationController?.dismiss(animated: true) {
//                       self.delegate?.applePayContext(self, didCompleteWith: .error, error: error)
//                       self.delegate = nil
                       self.authorizationController = nil
                       let _failure = PKPaymentAuthorizationResult(status: .failure, errors: [error!])
                       completion(_failure)
                   }
               }
               
               return
           case .success:
               var token = payment.token.paymentData.base64EncodedString().fromBase64()
               token = "{ \"paymentData\": \(token) }" //wrap token in paymentData object
               
               print("😀 apple pay token", token)
       
               self.paymentState = .success
               DispatchQueue.main.async {
                   self.authorizationController?.dismiss(animated: true) {
//                       self.delegate?.applePayContext(self, didCompleteWith: .success(token), error: nil)
                       let _success = PKPaymentAuthorizationResult(status: .success, errors: nil)
                       completion(_success)
                   }
               }
               
               return
           case .pending, .notStarted:
               return
           }
       }
       
//        let authData = AuthorisedPayment(
//            orderId: self.orderId,
//            flowId: self.flowId,
//            amount: String(amount),
//            currencyCode: self.currencyCode,
//            paymentMethod: PaymentDtoInput(
//                type: .applePay,
//                walletToken: token
//            )
//        )
//
//        Task {
//            do {
//                let authpayment = try await MangoPaySDK.authorizePayment(apikey: MangoPaySDK.apiKey, paymentData: authData)
//                handleFinalState(.success, nil)
//            } catch {
//                handleFinalState(.error, error)
//            }
//        }
   }
}
