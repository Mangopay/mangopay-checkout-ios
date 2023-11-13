//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation

public struct PaymentMethodConfig {
    var card: MGPCardInfo?
    var cardReg: MGPCardRegistration?
    var applePayConfig: MGPApplePayConfig?

    public init(card: MGPCardInfo? = nil, cardReg: MGPCardRegistration? = nil, applePayConfig: MGPApplePayConfig? = nil) {
        self.card = card
        self.cardReg = cardReg
        self.applePayConfig = applePayConfig
    }
}
