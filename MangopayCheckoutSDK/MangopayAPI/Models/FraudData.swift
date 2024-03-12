//
//  File 2.swift
//  
//
//  Created by Elikem Savie on 07/06/2023.
//

import Foundation
import MangopayVaultSDK

public typealias MangopayTokenizedCallBack = ((TokenizedCardData?, MGPError?) -> ())

public struct FraudData: Codable {
    let provider: String
    let profilingAttemptReference: String

    public init(provider: String = "Nethone", profilingAttemptReference: String) {
        self.provider = provider
        self.profilingAttemptReference = profilingAttemptReference
    }

    enum CodingKeys: String, CodingKey {
        case provider
        case profilingAttemptReference = "AttemptReference"
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
        guard let id = card.cardID else { return "" }
        return "Tokenised Card: \(id) \n FraudData: \(fraud.profilingAttemptReference)"
    }
}
