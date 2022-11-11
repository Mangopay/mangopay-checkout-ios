//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/10/2022.
//

import Foundation
import Apollo
import ApolloAPI
import SchemaPackage

public typealias TokeniseCard = TokeniseCardMutation.Data.TokeniseCard
public typealias AuthorizePaymentResponse = AuthorizePaymentMutation.Data.AuthorizePayment
public typealias ListCustomerCard = ListCustomerCardsQuery.Data.ListCustomerCard
public typealias GetPayment = GetPaymentQuery.Data.GetPayment


public class WhenThenClient {
    
    public static let shared = WhenThenClient(clientKey: WhenThenSDK.clientID)
    let indempodentKey = UUID().uuidString
    let version1UUID = UUID().version1UUID
    var clientKey: String!
        
    private(set) lazy var apollo: ApolloClient = {

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

    private(set) lazy var apollo2: ApolloClient = {

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

    init(clientKey: String) {
        self.clientKey = clientKey
    }

    public func fetchCards(with customerId: String?) async throws -> [ListCustomerCard] {

        let _customerId = customerId ?? "a4a7cb68-9ce6-4874-84df-276d7e9b235b"
        let query = ListCustomerCardsQuery(vaultCustomerId: _customerId)

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

    public func tokenizeCard(with card: PaymentCardInput) async throws -> TokeniseCard {
        
        let y = GraphQLNullable<SchemaPackage.PaymentCardInput>(card)
        let paymentMethodInput = SchemaPackage.PaymentMethodInput(card: y)

        let tokenInput = TokenInput(
            paymentMethod: paymentMethodInput
        )
        
        let mutation = TokeniseCardMutation(data: tokenInput)

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<TokeniseCard, Error>) in
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

    func authorizePayment(payment: AuthorisedPayment) async throws -> AuthorizePaymentResponse {

        let mutation = AuthorizePaymentMutation(authorisePayment: payment.toAuthorisedPaymentInput())
        
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

    func createCustomer(with customer: CustomerInputData) async throws -> String {
        
        let mutation = CreateCustomerMutation(data: customer.toDTO)
        
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

    func getPayment(with id: String) async throws -> GetPayment {
        let query = GetPaymentQuery(id: id)

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
}
