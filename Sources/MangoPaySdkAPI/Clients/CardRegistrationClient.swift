//
//  File.swift
//  
//
//  Created by Elikem Savie on 26/02/2023.
//

import Foundation

public protocol CardRegistrationClientProtocol {
    func createCardRegistration(
        _ card: CardRegistration,
        clientId: String,
        apiKey: String
    ) async throws -> CardRegistration
    func postCardInfo(_ cardInfo: CardInfo, url: URL) async throws -> CardInfo.RegistrationData
    func updateCardInfo(_ regData: CardInfo.RegistrationData, clientId: String, cardRegistrationId: String) async throws -> CardRegistration
}

public final class CardRegistrationClient: NetworkUtil, CardRegistrationClientProtocol {
    
    public init() { }

    public func createCardRegistration(
        _ card: CardRegistration,
        clientId: String,
        apiKey: String
    ) async throws -> CardRegistration {

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
            basicAuthDict: [
                "username" : clientId,
                "password": apiKey
            ],
            verbose: true
        )
    }
    
    public func postCardInfo(_ cardInfo: CardInfo, url: URL) async throws -> CardInfo.RegistrationData {

        print("🥹 cardInfo \(cardInfo)")

        return try await request(
            url: url,
            method: .post,
            additionalHeaders: [
                "Content-Type" : "application/x-www-form-urlencoded",
            ],
            bodyParam: cardInfo.toDict(),
            expecting: CardInfo.RegistrationData.self,
            verbose: true,
            useXXForm: true,
            decodeAsString: true
        )
    }

    public func updateCardInfo(
        _ regData: CardInfo.RegistrationData,
        clientId: String,
        cardRegistrationId: String) async throws -> CardRegistration {
        
        let url = baseUrl.appendingPathComponent(
            "/\(apiVersion)/\(clientId)/CardRegistrations/\(cardRegistrationId)",
            isDirectory: false
        )

        return try await request(
            url: url,
            method: .put,
            additionalHeaders: [
                "Content-Type" : "application/json",
            ],
            bodyParam: regData.toDict(),
            expecting: CardRegistration.self,
            verbose: true
        )
    }
    
}
