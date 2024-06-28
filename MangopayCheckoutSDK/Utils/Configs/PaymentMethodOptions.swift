//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation

public struct PaymentMethodOptions {
    var cardOptions: MGPCardOptions?
    var applePayOptions: MGPApplePayOptions?
    var paypalConfig: MGPPaypalOptions?

    public init(
        cardOptions: MGPCardOptions,
        applePayOptions: MGPApplePayOptions? = nil,
        paypalOptions: MGPPaypalOptions? = nil
    ) {
        self.cardOptions =  cardOptions
        self.applePayOptions = applePayOptions
        self.paypalConfig = paypalOptions
    }
}

