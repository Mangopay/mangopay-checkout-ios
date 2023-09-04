//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/08/2023.
//

import Foundation
import PassKit
import MangoPaySdkAPI

public struct MangopayApplePayConfig {
    var amount: Double
    var delegate: MangoPayApplePayDelegate
    var merchantIdentifier: String
    var merchantCapabilities: PKMerchantCapability
    var currencyCode: String
    var supportedCountries: [String]?
    var countryCode: String
    var supportedNetworks: [PKPaymentNetwork]
//    var captureBillingAddress: Bool?
    var buttonType: PKPaymentButtonType?
    var buttonStyle: PKPaymentButtonStyle?
    var requiredBillingContactFields: Set<PKContactField>?
    var billingContact: PKContact?
    var shippingContact: PKContact?
    var shippingType: PKShippingType?
    var shippingMethods: [PKShippingMethod]?
    var applicationData: Data?

    public init(amount: Double, delegate: MangoPayApplePayDelegate, merchantIdentifier: String, merchantCapabilities: PKMerchantCapability, currencyCode: String, supportedCountries: [String]? = nil, countryCode: String, supportedNetworks: [PKPaymentNetwork], buttonType: PKPaymentButtonType? = nil, buttonStyle: PKPaymentButtonStyle? = nil, requiredBillingContactFields: Set<PKContactField>? = nil, billingContact: PKContact? = nil, shippingContact: PKContact? = nil, shippingType: PKShippingType? = nil, shippingMethods: [PKShippingMethod]? = nil, applicationData: Data? = nil) {
        self.amount = amount
        self.delegate = delegate
        self.merchantIdentifier = merchantIdentifier
        self.merchantCapabilities = merchantCapabilities
        self.currencyCode = currencyCode
        self.supportedCountries = supportedCountries
        self.countryCode = countryCode
        self.supportedNetworks = supportedNetworks
        self.buttonType = buttonType
        self.buttonStyle = buttonStyle
        self.requiredBillingContactFields = requiredBillingContactFields
        self.billingContact = billingContact
        self.shippingContact = shippingContact
        self.shippingType = shippingType
        self.shippingMethods = shippingMethods
        self.applicationData = applicationData
    }

    func validate() throws {

        guard merchantIdentifier.isEmpty else {
            throw MGPError.applePayErrorMerchantIdEmpty
        }

        guard currencyCode.isEmpty else {
            throw MGPError.applePayErrorCurrencyCode
        }

        guard countryCode.isEmpty else {
            throw MGPError.applePayErrorCurrencyCode
        }

        guard amount <= 0 else {
            throw MGPError.applePayErrorAmount
        }
    }

    var isApplePayAvailableForUser: Bool {
        guard PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks) else {
            return false
        }
        return true
    }

    var shouldRenderApplePay: Bool {
        return isApplePayAvailableForUser &&
        !merchantIdentifier.isEmpty &&
        !currencyCode.isEmpty &&
        !countryCode.isEmpty
    }

    var toPaymentRequest: PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantIdentifier
        paymentRequest.merchantCapabilities = merchantCapabilities
        paymentRequest.currencyCode = currencyCode
        paymentRequest.supportedCountries = Set(supportedCountries ?? [])
        paymentRequest.supportedNetworks = supportedNetworks
        paymentRequest.countryCode = countryCode
//        paymentRequest.captureBillingAddress = captureBillingAddress
//        paymentRequest.buttonType = buttonType
        if let _requiredBillingContactFields = requiredBillingContactFields {
            paymentRequest.requiredBillingContactFields = _requiredBillingContactFields
        }

        if let _shippingType = shippingType {
            paymentRequest.shippingType = _shippingType
        }
        
        paymentRequest.billingContact = billingContact
        paymentRequest.shippingContact = shippingContact
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.applicationData = applicationData

        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(
                label: "Item",
                amount: NSDecimalNumber(value: amount))
        ]
        return paymentRequest
    }
    
    func shippingMethodCalculator() -> [PKShippingMethod] {
        // Calculate the pickup date.
        
        let today = Date()
        let calendar = Calendar.current
        
        let shippingStart = calendar.date(byAdding: .day, value: 3, to: today)!
        let shippingEnd = calendar.date(byAdding: .day, value: 5, to: today)!
        
        let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
        let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
         
        let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.00"))
//        shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
        shippingDelivery.detail = "Ticket sent to you address"
        shippingDelivery.identifier = "DELIVERY"
        
        let shippingCollection = PKShippingMethod(label: "Collection", amount: NSDecimalNumber(string: "0.00"))
        shippingCollection.detail = "Collect ticket at festival"
        shippingCollection.identifier = "COLLECTION"
        
        return [shippingDelivery, shippingCollection]
    }
}
