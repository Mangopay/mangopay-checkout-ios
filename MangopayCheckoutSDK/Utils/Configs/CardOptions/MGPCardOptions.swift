//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/03/2024.
//

import Foundation

public struct MGPCardOptions {
    var cardRegistration: MGPCardRegistration?
    var supportedCardBrands: [CardType]?

    public init(
        cardRegistration: MGPCardRegistration? = nil,
        supportedCardBrands: [CardType]? = nil
    ) {
        self.cardRegistration = cardRegistration
        self.supportedCardBrands = supportedCardBrands
    }
}
