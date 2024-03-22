//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation

public struct PaymentMethodOptions {
    var card: MGPCardInfo?
    var cardReg: MGPCardRegistration?
    var applePayConfig: MGPApplePayConfig?
    var paypalConfig: MGPPaypalConfig?

    public init(
        card: MGPCardInfo? = nil,
        cardReg: MGPCardRegistration? = nil,
        applePayConfig: MGPApplePayConfig? = nil,
        paypalConfig: MGPPaypalConfig? = nil
    ) {
        self.card = card
        self.cardReg = cardReg
        self.applePayConfig = applePayConfig
        self.paypalConfig = paypalConfig
    }
}
