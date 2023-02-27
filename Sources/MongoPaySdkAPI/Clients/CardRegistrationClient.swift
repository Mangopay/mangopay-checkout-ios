//
//  File.swift
//  
//
//  Created by Elikem Savie on 26/02/2023.
//

import Foundation

protocol CardRegistrationClientProtocol {
    func createCardRegistration(_ card: CardRegistration, clientId: String) async throws -> CardRegistration
    func postCardInfo(_ cardInfo: CardInfo, url: URL) async throws -> CardInfo.RegistrationData
    func updateCardInfo(_ cardInfo: CardInfo, clientId: String, cardRegistrationId: String) async throws -> CardInfo.RegistrationData
}

final class CardRegistrationClient: NetworkUtil, CardRegistrationClientProtocol {
    
    func createCardRegistration(_ card: CardRegistration, clientId: String) async throws -> CardRegistration {

        let url = baseUrl.appendingPathComponent(
            "/\(apiVersion)/\(clientId)/cardregistrations",
            isDirectory: false
        )
        print("🥹 card \(card)")

        return try await request(
            url: url,
            method: .post,
            bodyParam: card.toDict(),
            expecting: CardRegistration.self,
            verbose: true
        )
    }
    
    func postCardInfo(_ cardInfo: CardInfo, url: URL) async throws -> CardInfo.RegistrationData {

        print("🥹 cardInfo \(cardInfo)")

        return try await request(
            url: url,
            method: .post,
            bodyParam: cardInfo.toDict(),
            expecting: CardInfo.RegistrationData.self,
            verbose: true
        )
    }

    func updateCardInfo(_ cardInfo: CardInfo, clientId: String, cardRegistrationId: String) async throws -> CardInfo.RegistrationData {
        
        let url = baseUrl.appendingPathComponent(
            "/\(apiVersion)/\(clientId)/CardRegistrations/\(cardRegistrationId)",
            isDirectory: false
        )

        return try await request(
            url: url,
            method: .post,
            bodyParam: cardInfo.toDict(),
            expecting: CardInfo.RegistrationData.self,
            verbose: true
        )
    }
    
}
