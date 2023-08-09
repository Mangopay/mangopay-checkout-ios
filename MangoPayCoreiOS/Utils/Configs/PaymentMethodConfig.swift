//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation
import MangoPaySdkAPI

public struct PaymentMethodConfig {
    var card: MGPCardInfo?
    var cardReg: MGPCardRegistration?
    var applePay: MangoPayApplePay?

    public init(card: MGPCardInfo? = nil, cardReg: MGPCardRegistration? = nil, applePay: MangoPayApplePay? = nil) {
        self.card = card
        self.cardReg = cardReg
        self.applePay = applePay
    }
}
