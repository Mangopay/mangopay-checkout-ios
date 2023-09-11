/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A shared class for handling payments across an app and its related extensions.
*/

import UIKit
import PassKit


class MGPApplePayHandler: NSObject {

    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler!
    var pareq: PKPaymentRequest!
    var delegate: MGPApplePayHandlerDelegate?

    func setData(payRequest: PKPaymentRequest) {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = payRequest.paymentSummaryItems
        paymentRequest.merchantIdentifier = payRequest.merchantIdentifier
        paymentRequest.merchantCapabilities = payRequest.merchantCapabilities
        paymentRequest.countryCode = payRequest.countryCode
        paymentRequest.currencyCode = payRequest.currencyCode
        paymentRequest.supportedNetworks = payRequest.supportedNetworks
        paymentRequest.shippingType = payRequest.shippingType
        paymentRequest.shippingMethods = payRequest.shippingMethods
        paymentRequest.requiredShippingContactFields = payRequest.requiredShippingContactFields
        if #available(iOS 15.0, *) {
#if !os(watchOS)
            paymentRequest.supportsCouponCode = true
#endif
        } else {
            // Fallback on earlier versions
        }
        
        paymentRequest.paymentSummaryItems = payRequest.paymentSummaryItems
        pareq = paymentRequest
    }
    
    func startPayment(delegate: MGPApplePayHandlerDelegate, completion: @escaping PaymentCompletionHandler) {
        self.delegate = delegate
        completionHandler = completion
        paymentController = PKPaymentAuthorizationController(paymentRequest: pareq!)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
                self.completionHandler(false)
            }
        })
    }
}

extension MGPApplePayHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        // Perform basic validation on the provided contact information.
        var errors = [Error]()
        var status = PKPaymentAuthorizationStatus.success
        if payment.shippingContact?.postalAddress?.isoCountryCode != "US" {
            let pickupError = PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "Sample App only available in the United States")
            let countryError = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressCountryKey, localizedDescription: "Invalid country")
            errors.append(pickupError)
            errors.append(countryError)
            status = .failure
        } else {

        }
        
        let token = payment.token.paymentData.base64EncodedString().fromBase64()

        print("✅ token,", token)
        self.paymentStatus = status
        self.delegate?.applePayContext(didCompleteWith: .success(token), error: nil)
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // The payment sheet doesn't automatically dismiss once it has finished. Dismiss the payment sheet.
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
    
}
