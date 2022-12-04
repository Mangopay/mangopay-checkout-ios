//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by Elikem Savie on 04/12/2022.
//

import UIKit
import PassKit

class ViewController: UIViewController {
    
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//                controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        // Perform basic validation on the provided contact information.
        let errors = [Error]()
        
        var token = payment.token.paymentData
        print("token,", token)
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        
    }
}
