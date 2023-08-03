//
//  File.swift
//  
//
//  Created by Elikem Savie on 31/07/2023.
//

import Foundation
import MangoPaySdkAPI
import MangopayVault

struct Tokenizer {
    
    private static var clientId: String!
    private static var environment: MGPEnvironment!

    public static func initialize(
        clientId: String,
        environment: MGPEnvironment
    ) {
        self.clientId = clientId
        self.environment = environment
        MangopayVault.initialize(clientId: clientId, environment: environment == .sandbox ? .sandbox : .prod)
    }

    public static func tokenize(
        card: MGPCardInfo,
        with cardReg: CardRegistration,
        nethoeAttemptedRef: String,
        mangoPayVaultCallback: @escaping MangoPayTokenizedCallBack
    ) {

        guard clientId != nil, !clientId.isEmpty else {
            mangoPayVaultCallback(.none, MGPError.initializationRqd)
            return
        }

         MangopayVault.tokenizeCard(
            card: CardInfo(
                cardNumber: card.cardNumber,
                cardExpirationDate: card.cardExpirationDate,
                cardCvx: card.cardCvx,
                cardType: card.cardType,
                accessKeyRef: card.accessKeyRef,
                data: card.data
            ),
            cardRegistration: cardReg) { tokenisedCard, error in
                guard let _card = tokenisedCard else {
                    mangoPayVaultCallback(.none, MGPError.tokenizationError(additionalInfo: error?.localizedDescription))
                    return
                    
                }
                let res = TokenizedCardData(
                    card: _card,
                    fraud: FraudData(attemptReference: nethoeAttemptedRef)
                )
                mangoPayVaultCallback(res, .none)
            }
        
    }
    
    
}
