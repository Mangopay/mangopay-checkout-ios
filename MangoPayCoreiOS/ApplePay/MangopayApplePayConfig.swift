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
    var delegage: MangoPayApplePayDelegate
    var merchantIdentifier: String
    var merchantCapabilities: PKMerchantCapability
    var currencyCode: String
    var supportedCountries: [String]?
    var countryCode: String
    var supportedNetworks: [PKPaymentNetwork]
    var captureBillingAddress: Bool?
    var buttonType: PKPaymentButtonType?
    var buttonStyle: PKPaymentButtonStyle?
    var requiredBillingContactFields: Set<PKContactField>?
    var billingContact: PKContact?
    var shippingContact: PKContact?
    var shippingType: PKShippingType?
    var shippingMethods: [PKShippingMethod]?
    var applicationData: Data?

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
}
