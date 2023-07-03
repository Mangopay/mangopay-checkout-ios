//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/10/2022.
//

import Foundation
import Apollo
#if !COCOAPODS
import ApolloAPI
#endif

public typealias TokenizeCard = CheckoutSchema.TokeniseCardMutation.Data.TokeniseCard
public typealias AuthorizePaymentResponse = CheckoutSchema.AuthorizePaymentMutation.Data.AuthorizePayment
public typealias ListCustomerCard = CheckoutSchema.ListCustomerCardsQuery.Data.ListCustomerCard
public typealias GetPayment = CheckoutSchema.GetPaymentQuery.Data.GetPayment
public typealias PaymentCardInput = CheckoutSchema.PaymentCardInput
public typealias GetPaymentMethod = CheckoutSchema.GetPaymentMethodsQuery.Data.GetPaymentMethod

public typealias IntentCustomerInput = CheckoutSchema.IntentCustomerInput
public typealias IntentAmountInput = CheckoutSchema.IntentAmountInput
public typealias IntentCartInput = CheckoutSchema.IntentCartInput
public typealias IntentLocationInput = CheckoutSchema.IntentLocationInput
public typealias IntentShippingInput = CheckoutSchema.IntentShippingInput
public typealias IntentDeliveryInput = CheckoutSchema.IntentDeliveryInput

public typealias MangoPayCallBack = ((MGPCardRegistration?, Error?) -> ())
public typealias MangoPayTokenizedCallBack = ((TokenizedCardData?, Error?) -> ())

public enum MGPEnvironment: String {
    case sandbox
    case prod

    public var url: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://api.sandbox.mangopay.com")!
        case .prod:
            return URL(string: "https://api.mangopay.com")!
        }
    }
}

public protocol MangoPayClientSessionProtocol {
    var clientKey: String! { get set }
    var apiKey: String! { get set }
    func tokenizeCard(
        with card: CheckoutSchema.PaymentCardInput,
        customer: Customer?
    ) async throws -> TokenizeCard
}

public protocol MangoPayinProtocol {
    var apiKey: String! { get set }
    var environment: MGPEnvironment { get set }

    func createCardRegistration(_ card: MangoPaySdkAPI.MGPCardRegistration.Initiate, clientId: String, apiKey: String) async throws -> MGPCardRegistration

    func postCardInfo(_ cardInfo: MangoPaySdkAPI.MGPCardInfo, url: URL) async throws -> MGPCardInfo.RegistrationData

    func updateCardInfo(_ regData: MangoPaySdkAPI.MGPCardInfo.RegistrationData, clientId: String, cardRegistrationId: String) async throws -> MGPCardRegistration
}

public class MangoPayClient: MangoPayClientSessionProtocol {
    public var apiKey: String!

    let indempodentKey = UUID().uuidString
    let version1UUID = UUID().version1UUID
    public var clientKey: String!
    public var environment: MGPEnvironment = .sandbox
    var payClient: CardRegistrationClient!
        
    fileprivate(set) lazy var apollo: ApolloClient = {

        let apiEndpoint = "https://api.dev.whenthen.co/api/graphql"
        let url = URL(string: apiEndpoint)!
        
        let store = ApolloStore()
        
        let interceptorProvider = NetworkInterceptorsProvider(
            interceptors: [
                TokenInterceptor(
                    token: clientKey,
                    indempodentKey: indempodentKey
                )
            ],
            store: store
        )

        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider,
            endpointURL: url
        )

        return ApolloClient(networkTransport: networkTransport, store: store)
    }()

    fileprivate(set) lazy var apollo2: ApolloClient = {

        let apiEndpoint = "https://api.dev.whenthen.co/api/graphql"
        let url = URL(string: apiEndpoint)!
        
        let store = ApolloStore()
        
        let interceptorProvider = NetworkInterceptorsProvider(
            interceptors: [
                TokenInterceptor(
                    token: clientKey,
                    indempodentKey: version1UUID
                )
            ],
            store: store
        )

        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider,
            endpointURL: url
        )

        return ApolloClient(networkTransport: networkTransport, store: store)
    }()

    public init(clientKey: String) {
        self.clientKey = clientKey
    }

    public init(clientKey: String, apiKey: String = "", environment: MGPEnvironment) {
        self.clientKey = clientKey
        self.apiKey = apiKey
        self.environment = environment
        self.payClient = CardRegistrationClient(env: environment)
    }

    public func fetchCards(with customerId: String?) async throws -> [ListCustomerCard] {

        let _customerId = customerId ?? "a4a7cb68-9ce6-4874-84df-276d7e9b235b"
        let query = CheckoutSchema.ListCustomerCardsQuery(vaultCustomerId: _customerId)

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[ListCustomerCard], Error>) in
            apollo.fetch(query: query) { result in
                switch result {
                case .success(let reponse):
                    print("✅ fetchCards ")
                    if let listCustomerCards = reponse.data?.listCustomerCards?.compactMap({$0}) {
                        continuation.resume(returning: listCustomerCards)
                    }
                case .failure(let error):
                    print("❌ Failed to fetch Cards ..\(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    public func tokenizeCard(
        with card: CheckoutSchema.PaymentCardInput,
        customer: Customer?
    ) async throws -> TokenizeCard {
        
        let y = GraphQLNullable<CheckoutSchema.PaymentCardInput>(card)
        let paymentMethodInput = CheckoutSchema.PaymentMethodInput(card: y)

        let tokenInput = CheckoutSchema.TokenInput( 
            paymentMethod: paymentMethodInput,
            customer: customer != nil ? .some(customer!.toDTO) : .null
        )
        
        let mutation = CheckoutSchema.TokeniseCardMutation(data: tokenInput)

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<TokenizeCard, Error>) in
            apollo.perform(mutation: mutation) { result in
                switch result {
                case .success(let reponse):
                    print("🤣 tokenizeCard ")
                    //                dump(reponse.data)
                    if let _data = reponse.data {
                        print("🤣 _data", _data)
                        continuation.resume(returning: _data.tokeniseCard)
                    } else if let errrs = reponse.errors {
                        print("Card tokenizing error \(errrs)")
                        continuation.resume(throwing: errrs.first!)
                    }
                case .failure(let error):
                    print("❌ Failed to tokenizeCard .. \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    public func authorizePayment(payment: AuthorisedPayment) async throws -> AuthorizePaymentResponse {

        let mutation = CheckoutSchema.AuthorizePaymentMutation(authorisePayment: payment.toAuthorisedPaymentInput())
        
        print("auth data mutation,", payment.toAuthorisedPaymentInput())

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<AuthorizePaymentResponse, Error>) in
            
            apollo2.perform(mutation: mutation)  { result in
                switch result {
                case .success(let reponse):
                    if let _data = reponse.data?.authorizePayment {
                        print("🤣 authorizePayment", _data)
                        continuation.resume(returning: _data)
                    } else if let errrs = reponse.errors {
                        print("❌ authorizePayment error \(errrs)")
                        continuation.resume(throwing: errrs.first!)
                    }

                case .failure(let error):
                    print("❌ Failed to authorizePayment ..")
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    public func createCustomer(with customer: CustomerInputData) async throws -> String {
        
        let mutation = CheckoutSchema.CreateCustomerMutation(data: customer.toDTO)
        
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<String, Error>) in
            
            apollo.perform(mutation: mutation)  { result in
                switch result {
                case .success(let reponse):
                    print("🤣 createCustomer", reponse.data?.createCustomer)
                    if let createCustomerStr = reponse.data?.createCustomer {
                        continuation.resume(returning: createCustomerStr)
                    } else if let errrs = reponse.errors {
                        print("createCustomer error \(errrs)")
                        continuation.resume(throwing: errrs.first!)
                    }
                    
                case .failure(let error):
                    print("❌ Failed to authorizePayment ..")
                    continuation.resume(throwing: error)
                }
            }
        })
        
    }

    public func getPayment(with id: String) async throws -> GetPayment {
        let query = CheckoutSchema.GetPaymentQuery(id: id)

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<GetPayment, Error>) in
            apollo.fetch(query: query) { result in
                switch result {
                case .success(let reponse):
                    if let getPayment = reponse.data?.getPayment {
                        continuation.resume(returning: getPayment)
                    }
                case .failure(let error):
                    print("❌ Failed to get Payment ..\(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    public func getPaymentMethodsForCustomer(_ customerId: String) async throws -> [GetPaymentMethod?] {
        let query = CheckoutSchema.GetPaymentMethodsQuery(customerId: customerId)
    
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[GetPaymentMethod?], Error>) in
            apollo.fetch(query: query) { result in
                switch result {
                case .success(let reponse):
                    if let getPayment = reponse.data?.getPaymentMethods {
                        continuation.resume(returning: getPayment)
                    }
                case .failure(let error):
                    print("❌ Failed to get Payment ..\(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        })
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

