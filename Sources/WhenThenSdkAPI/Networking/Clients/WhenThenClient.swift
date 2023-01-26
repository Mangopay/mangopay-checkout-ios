//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/10/2022.
//

import Foundation
import Apollo
import ApolloAPI

public typealias TokeniseCard = CheckoutSchema.TokeniseCardMutation.Data.TokeniseCard
public typealias AuthorizePaymentResponse = CheckoutSchema.AuthorizePaymentMutation.Data.AuthorizePayment
public typealias ListCustomerCard = CheckoutSchema.ListCustomerCardsQuery.Data.ListCustomerCard
public typealias GetPayment = CheckoutSchema.GetPaymentQuery.Data.GetPayment
public typealias PaymentCardInput = CheckoutSchema.PaymentCardInput

public typealias IntentCustomerInput = CheckoutSchema.IntentCustomerInput
public typealias IntentAmountInput = CheckoutSchema.IntentAmountInput
public typealias IntentCartInput = CheckoutSchema.IntentCartInput
public typealias IntentLocationInput = CheckoutSchema.IntentLocationInput
public typealias IntentShippingInput = CheckoutSchema.IntentShippingInput
public typealias IntentDeliveryInput = CheckoutSchema.IntentDeliveryInput


public class WhenThenClient {
    
    let indempodentKey = UUID().uuidString
    let version1UUID = UUID().version1UUID
    var clientKey: String!
        
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

    public func tokenizeCard(with card: CheckoutSchema.PaymentCardInput) async throws -> TokeniseCard {
        
        let y = GraphQLNullable<CheckoutSchema.PaymentCardInput>(card)
        let paymentMethodInput = CheckoutSchema.PaymentMethodInput(card: y)

        let tokenInput = CheckoutSchema.TokenInput(
            paymentMethod: paymentMethodInput
        )
        
        let mutation = CheckoutSchema.TokeniseCardMutation(data: tokenInput)

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
}

extension WhenThenClient {

    public func startIntent(
        trackingId: String,
        flowId: String,
        customer: IntentCustomerInput? = nil,
        amount: IntentAmountInput? = nil,
        location: IntentLocationInput? = nil,
        cart: IntentCartInput? = nil
    ) async throws -> CheckoutSchema.StartIntentMutation.Data.StartIntent {
        
//        let _location = GraphQLNullable<CheckoutSchema.IntentLocationInput>(location) ?? .none
//        let _customer = GraphQLNullable<CheckoutSchema.IntentCustomerInput>(customer ?? .none)
//        let _cart = GraphQLNullable<CheckoutSchema.IntentCartInput>(cart ?? .none)

        let mutation = CheckoutSchema.StartIntentMutation(
            trackingId: trackingId,
            paymentFlowId: flowId,
            customer: nil,
            amount: CheckoutSchema.IntentAmountInput(amount: 20, currency: "USD"),
            location: nil,
            cart: nil
        )
        
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<CheckoutSchema.StartIntentMutation.Data.StartIntent, Error>) in
            
            apollo.perform(mutation: mutation)  { result in
                switch result {
                case .success(let reponse):
                    print("🤣 StartingINtent", reponse.data)
                    if let startIntent = reponse.data?.startIntent {
                        continuation.resume(returning: startIntent)
                    } else if let errrs = reponse.errors {
                        print("Start Intent error \(errrs)")
                        continuation.resume(throwing: errrs.first!)
                    }
                    
                case .failure(let error):
                    print("❌ Failed to startIntent ..")
                    continuation.resume(throwing: error)
                }
            }
        })

    }

//    public func updateIntent(
//        intentId: String,
//        trackingId: String,
//        customer: IntentCustomerInput,
//        amount: IntentAmountInput,
//        location: IntentLocationInput,
//        shiping: IntentShippingInput,
//        billing: IntentShippingInput,
//        delivery: IntentDeliveryInput
//    ) async throws -> CheckoutSchema.UpdateIntentMutation.Data.UpdateIntent {
//        
//        let _customer = GraphQLNullable<CheckoutSchema.IntentCustomerInput>(customer)
//        let _amount = GraphQLNullable<CheckoutSchema.IntentAmountInput>(amount)
//        let _location = GraphQLNullable<CheckoutSchema.IntentLocationInput>(location)
//        let _shipping = GraphQLNullable<CheckoutSchema.IntentShippingInput>(shiping)
//        let _billing = GraphQLNullable<CheckoutSchema.IntentShippingInput>(shiping)
//        let _delivery = GraphQLNullable<CheckoutSchema.IntentDeliveryInput>(delivery)
//
//        let mutation = CheckoutSchema.UpdateIntentMutation(
//            id: intentId,
//            trackingId: trackingId.toGraphQLNullable(),
//            customer: _customer,
//            amount: _amount,
//            shipping: _shipping,
//            delivery: _delivery,
//            billing: _billing,
//            location: _location
//        )
//
//        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<CheckoutSchema.UpdateIntentMutation.Data.UpdateIntent, Error>) in
//            
//            apollo.perform(mutation: mutation)  { result in
//                switch result {
//                case .success(let reponse):
//                    print("🤣 Updating Intent", reponse.data?.updateIntent)
//                    if let updateIntent = reponse.data?.updateIntent {
//                        continuation.resume(returning: updateIntent)
//                    } else if let errrs = reponse.errors {
//                        print("Start Intent error \(errrs)")
//                        continuation.resume(throwing: errrs.first!)
//                    }
//                    
//                case .failure(let error):
//                    print("❌ Failed to Update Intent ..")
//                    continuation.resume(throwing: error)
//                }
//            }
//        })
//    }
//
//    public func completeIntent(intentId: String, paymentReference: String) async throws -> CheckoutSchema.CompleteIntentMutation.Data.CompleteIntent {
//        let mutation = CheckoutSchema.CompleteIntentMutation(id: intentId, paymentReference: paymentReference)
//
//        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<CheckoutSchema.CompleteIntentMutation.Data.CompleteIntent, Error>) in
//            
//            apollo.perform(mutation: mutation)  { result in
//                switch result {
//                case .success(let reponse):
//                    print("🤣 Complete Intent", reponse.data?.completeIntent)
//                    if let updateIntent = reponse.data?.completeIntent {
//                        continuation.resume(returning: updateIntent)
//                    } else if let errrs = reponse.errors {
//                        print("Complete Intent error \(errrs)")
//                        continuation.resume(throwing: errrs.first!)
//                    }
//                    
//                case .failure(let error):
//                    print("❌ Failed to Update Intent ..")
//                    continuation.resume(throwing: error)
//                }
//            }
//        })
//    }
//
//    public func getIntent(intentId: String, paymentReference: String) async throws -> CheckoutSchema.GetIntentQuery.Data.GetIntent {
//    
//        let query = CheckoutSchema.GetIntentQuery(id: intentId)
//
//        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<CheckoutSchema.GetIntentQuery.Data.GetIntent, Error>) in
//            apollo.fetch(query: query) { result in
//                switch result {
//                case .success(let reponse):
//                    if let getPayment = reponse.data?.getIntent {
//                        continuation.resume(returning: getPayment)
//                    }
//                case .failure(let error):
//                    print("❌ Failed to get Intent ..\(error.localizedDescription)")
//                    continuation.resume(throwing: error)
//                }
//            }
//        })
//    }
//
//    public func optimiseIntent(_ intentId: String) async throws -> [GraphQLEnum<CheckoutSchema.PaymentMethodEnum>] {
//    
//        let query = CheckoutSchema.OptimiseQuery(intentId: intentId)
//
//        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[GraphQLEnum<CheckoutSchema.PaymentMethodEnum>], Error>) in
//            apollo.fetch(query: query) { result in
//                switch result {
//                case .success(let reponse):
//                    if let paymentMethods = reponse.data?.optimise {
//                        continuation.resume(returning: paymentMethods)
//                    }
//                case .failure(let error):
//                    print("❌ Failed to Optimise ..\(error.localizedDescription)")
//                    continuation.resume(throwing: error)
//                }
//            }
//        })
//    }
}
