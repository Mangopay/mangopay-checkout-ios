//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation

public class PaymentCore {

    public var apiKey: String!
    public var clientKey: String!
    public var environment: MGPEnvironment = .sandbox

    private let payClient: PaymentCoreClientProtocol!

    public init(
        clientKey: String,
        apiKey: String = "",
        environment: MGPEnvironment
    ) {
        self.clientKey = clientKey
        self.apiKey = apiKey
        self.environment = environment
        self.payClient = PaymentCoreClient(env: environment)
    }

    public func authorizePaymentPayIn(payment: AuthorizePayIn) async throws -> AuthorizePayIn {

        do {
            let authRes = try await payClient.authorizePayIn(payment, clientId: clientKey, apiKey: apiKey)
            return authRes
        } catch {
            print("❌ Failed to authorizePayment -> PayIn..")
            throw error
        }
    }

    public func getPayIn(payInId: String) async throws -> PayIn {

        do {
            let payIn = try await payClient.getPayIn(clientId: clientKey, apiKey: apiKey, payInId: payInId)
            return payIn
        } catch {
            print("❌ Failed to Get PayIn -> PayIn..")
            throw error
        }
    }

    public func listPayInCards(userId: String, isActive: Bool) async throws -> [PayInCard] {

        do {
            let payInCards = try await payClient.fetchPayInCards(clientId: clientKey, apiKey: apiKey, userId: userId, active: isActive)
            return payInCards
        } catch {
            print("❌ Failed to fetchPayInCards -> PayIn..")
            throw error
        }
    }

    public func createCardRegistration(card: MGPCardRegistration.Initiate, clientId: String, apiKey: String) async throws -> MGPCardRegistration {

        do {
            let createdCard = try await payClient.createCardRegistration(card, clientId: clientId, apiKey: apiKey)
            return createdCard
        } catch {
            print("❌ Failed to createCardRegistration -> PayIn..")
            throw error
        }
    }

    public func createPreAuth(preAuth: PreAuthCard, clientId: String, apiKey: String) async throws -> PreAuthCard {

        do {
            let createdPreAuth = try await payClient.createPreAuth(clientId: clientId, apiKey: apiKey, preAuth: preAuth)
            return createdPreAuth
        } catch {
            print("❌ Failed to createPreAuth -> PayIn..")
            throw error
        }
    }

    public func viewPreAuth(preAuthId: String, clientId: String, apiKey: String) async throws -> PreAuthCard {

        do {
            let createdPreAuth = try await payClient.viewPreAuth(clientId: clientId, apiKey: apiKey, preAuthId: preAuthId)
            return createdPreAuth
        } catch {
            print("❌ Failed to createPreAuth -> PayIn..")
            throw error
        }
    }
}
