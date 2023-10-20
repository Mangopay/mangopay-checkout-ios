//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/08/2023.
//

import Foundation
import PassKit


public struct MangopayApplePayConfig {
    var amount: Double
    var delegate: MGPApplePayHandlerDelegate
    var merchantIdentifier: String
    var merchantCapabilities: PKMerchantCapability
    var currencyCode: String
    var supportedCountries: [String]?
    var countryCode: String
    var supportedNetworks: [PKPaymentNetwork]
    var buttonType: PKPaymentButtonType?
    var buttonStyle: PKPaymentButtonStyle?
    var requiredBillingContactFields: Set<PKContactField>?
    var billingContact: PKContact?
    var shippingContact: PKContact?
    var shippingType: PKShippingType?
    var shippingMethods: [PKShippingMethod]?
    var applicationData: Data?
    var requiredShippingContactFields: Set<PKContactField>? = nil

    var paymentSummaryItems = [PKPaymentSummaryItem]()

    public init(
        amount: Double,
        delegate: MGPApplePayHandlerDelegate,
        merchantIdentifier: String,
        merchantCapabilities: PKMerchantCapability,
        currencyCode: String,
        supportedCountries: [String]? = nil,
        countryCode: String,
        supportedNetworks: [PKPaymentNetwork],
        buttonType: PKPaymentButtonType? = nil,
        buttonStyle: PKPaymentButtonStyle? = nil,
        requiredBillingContactFields: Set<PKContactField>? = nil,
        billingContact: PKContact? = nil,
        shippingContact: PKContact? = nil,
        shippingType: PKShippingType? = nil,
        shippingMethods: [PKShippingMethod]? = nil,
        applicationData: Data? = nil,
        requiredShippingContactFields: Set<PKContactField>? = nil
    ) {
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
        self.requiredShippingContactFields = requiredShippingContactFields
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
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.currencyCode = currencyCode
        paymentRequest.supportedCountries = Set(supportedCountries ?? [])
        paymentRequest.supportedNetworks = supportedNetworks
        paymentRequest.countryCode = countryCode

        if let _requiredBillingContactFields = requiredBillingContactFields {
            paymentRequest.requiredBillingContactFields = _requiredBillingContactFields
        }
        if let _shippingType = shippingType {
            paymentRequest.shippingType = _shippingType
        }
        
        if let _requiredShippingContactFields = requiredShippingContactFields {
            paymentRequest.requiredShippingContactFields = _requiredShippingContactFields
        }
        
        paymentRequest.billingContact = billingContact
        paymentRequest.shippingContact = shippingContact
        paymentRequest.shippingMethods = shippingMethods
        paymentRequest.applicationData = applicationData

        if #available(iOS 15.0, *) {
         #if !os(watchOS)
            paymentRequest.supportsCouponCode = true
         #endif
        } else {
            // Fallback on earlier versions
        }
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(
                label: "Item",
                amount: NSDecimalNumber(value: amount))
        ]
        
        
        return paymentRequest
    }

}
