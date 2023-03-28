//
//  File.swift
//  
//
//  Created by Elikem Savie on 15/01/2023.
//

import Foundation
import Apollo
import ApolloAPI
import MangoPaySdkAPI

public class MangoPayIntent {
    
    var clientKey: String!
    let indempodentKey = UUID().uuidString

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

    public init(clientKey: String) {
        self.clientKey = clientKey
    }

    public func startIntent(
        trackingId: String,
        flowId: String,
        customer: MGPCustomerIntentInput? = nil,
        amount: MGPIntentAmountInput? = nil,
        location: MGPIntentLocationInput? = nil,
        cart: IntentCartInput? = nil
    ) async throws -> CheckoutSchema.StartIntentMutation.Data.StartIntent {

        print("✅ trackingId", trackingId)
        print("✅ flowId", flowId)
        let mutation = CheckoutSchema.StartIntentMutation(
            trackingId: trackingId,
            paymentFlowId: flowId,
            customer: customer?.toDTO ?? nil,
            amount: amount?.toDTO ?? MGPIntentAmountInput(amount: 0, currency: "USD").toDTO,
            location: location?.toDTO ?? nil,
            cart: nil
        )
        
        print("🤣 mutationData", mutation)
        
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<CheckoutSchema.StartIntentMutation.Data.StartIntent, Error>) in
            
            apollo.perform(mutation: mutation)  { result in
                switch result {
                case .success(let reponse):
//                    print("🤣 StartingINtent", reponse.data)
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

    public func updateIntent(
        intentId: String,
        trackingId: String?,
        customer: MGPCustomerIntentInput? = nil,
        amount: MGPIntentAmountInput? = nil,
        location: MGPIntentLocationInput? = nil,
        shipping: MGPShippingDeliveryInput? = nil,
        billing: MGPShippingDeliveryInput? = nil,
        delivery: MGPShippingDeliveryInput? = nil
    ) async throws -> CheckoutSchema.UpdateIntentMutation.Data.UpdateIntent {
        

        let mutation = CheckoutSchema.UpdateIntentMutation(
            id: intentId,
            trackingId: trackingId?.toGraphQLNullable() ?? nil,
            customer: customer?.toDTO ?? nil,
            amount: amount?.toDTO ?? nil,
            shipping: shipping?.toShippingDTO ?? nil,
            delivery: delivery?.toDeliveryDTO ?? nil,
            billing: billing?.toShippingDTO ?? nil,
            location: location?.toDTO ?? nil
        )

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<CheckoutSchema.UpdateIntentMutation.Data.UpdateIntent, Error>) in
            
            apollo.perform(mutation: mutation)  { result in
                switch result {
                case .success(let reponse):
//                    print("🤣 Updating Intent", reponse.data?.updateIntent)
                    if let updateIntent = reponse.data?.updateIntent {
                        continuation.resume(returning: updateIntent)
                    } else if let errrs = reponse.errors {
                        print("Start Intent error \(errrs)")
                        continuation.resume(throwing: errrs.first!)
                    }
                    
                case .failure(let error):
                    print("❌ Failed to Update Intent ..")
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    public func completeIntent(intentId: String, paymentReference: String) async throws -> CheckoutSchema.CompleteIntentMutation.Data.CompleteIntent {
        let mutation = CheckoutSchema.CompleteIntentMutation(id: intentId, paymentReference: paymentReference)

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<CheckoutSchema.CompleteIntentMutation.Data.CompleteIntent, Error>) in
            
            apollo.perform(mutation: mutation)  { result in
                switch result {
                case .success(let reponse):
                    print("🤣 Complete Intent", reponse.data?.completeIntent)
                    if let updateIntent = reponse.data?.completeIntent {
                        continuation.resume(returning: updateIntent)
                    } else if let errrs = reponse.errors {
                        print("Complete Intent error \(errrs)")
                        continuation.resume(throwing: errrs.first!)
                    }
                    
                case .failure(let error):
                    print("❌ Failed to Update Intent ..")
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    public func getIntent(intentId: String, paymentReference: String) async throws -> CheckoutSchema.GetIntentQuery.Data.GetIntent {
    
        let query = CheckoutSchema.GetIntentQuery(id: intentId)

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<CheckoutSchema.GetIntentQuery.Data.GetIntent, Error>) in
            apollo.fetch(query: query) { result in
                switch result {
                case .success(let reponse):
                    if let getPayment = reponse.data?.getIntent {
                        continuation.resume(returning: getPayment)
                    }
                case .failure(let error):
                    print("❌ Failed to get Intent ..\(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    public func optimise(_ intentId: String) async throws -> [GraphQLEnum<CheckoutSchema.PaymentMethodEnum>] {
    
        let query = CheckoutSchema.OptimiseQuery(intentId: intentId)

        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[GraphQLEnum<CheckoutSchema.PaymentMethodEnum>], Error>) in
            apollo.fetch(query: query) { result in
                switch result {
                case .success(let reponse):
                    if let paymentMethods = reponse.data?.optimise {
                        continuation.resume(returning: paymentMethods)
                    }
                case .failure(let error):
                    print("❌ Failed to Optimise ..\(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        })
    }

}
