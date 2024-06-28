//
//  File 2.swift
//  
//
//  Created by Elikem Savie on 07/06/2023.
//

import Foundation
import MangopayVaultSDK

public typealias MangopayTokenizedCallBack = ((TokenizedCardData?, MGPError?) -> ())


public struct TokenizedCardData: Codable {
    public var card: CardRegistration
    public var profilingAttemptReference: String

    public init(card: CardRegistration, profilingAttemptReference: String) {
        self.card = card
        self.profilingAttemptReference = profilingAttemptReference
    }

    public var str: String {
        guard let id = card.cardID else { return "" }
        return "Tokenised Card: \(id) \n FraudRef: \(profilingAttemptReference)"
    }
}
