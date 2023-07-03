//
//  File 2.swift
//  
//
//  Created by Elikem Savie on 07/06/2023.
//

import Foundation

struct FraudData: Codable {
    let provider: String
    let attemptReference: String

    init(provider: String, attemptReference: String) {
        self.provider = provider
        self.attemptReference = attemptReference
    }
}

struct TokeniszedCardData: Codable {
    
    var card: CardRegistration
}
