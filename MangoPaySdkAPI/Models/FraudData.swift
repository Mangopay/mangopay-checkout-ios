//
//  File 2.swift
//  
//
//  Created by Elikem Savie on 07/06/2023.
//

import Foundation
import MangopayVault

public typealias MangoPayTokenizedCallBack = ((TokenizedCardData?, MGPError?) -> ())

public struct FraudData: Codable {
    let provider: String
    let attemptReference: String

    public init(provider: String = "Nethone", attemptReference: String) {
        self.provider = provider
        self.attemptReference = attemptReference
    }

    enum CodingKeys: String, CodingKey {
        case provider
        case attemptReference = "AttemptReference"
    }
}

public struct TokenizedCardData: Codable {
    public var card: CardRegistration
    public var fraud: FraudData

    public init(card: CardRegistration, fraud: FraudData) {
        self.card = card
        self.fraud = fraud
    }

    public var str: String {
        return "Tokenised Card: \(card.cardID) \n FraudData: \(fraud)"
    }
}
