//
//  File.swift
//  
//
//  Created by Elikem Savie on 04/10/2022.
//

import Foundation
import Apollo
import ApolloAPI

public struct Example {

    private let apiKey = ""
    private let apiEndpoint = "https://api.sandbox.whenthen.co/api/graphql"

    private(set) lazy var apollo: ApolloClient = {
        
//        let cache = InMemoryNormalizedCache()
//        let store = ApolloStore(cache: cache)
//        let idempotencyKey = UUID().uuidString
//
//        let authPayloads = [
//            "Authorization": "Bearer \(self.apiKey)",
//            "X-Idempotency-Key": idempotencyKey
//        ]
//
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = authPayloads
//
//        let client = URLSessionClient(sessionConfiguration: configuration, callbackQueue:nil)
//
//        let provider = NetworkInterceptorProvider(client:client, store: store)
//
//        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider as InterceptorProvider, endpointURL: URL(string: self.apiEndpoint)!)
//
//        return ApolloClient(networkTransport: requestChainTransport, store: store)
        return ApolloClient(url: URL(string: apiEndpoint)!)

    }()

//    func fetch() {
//        Authori
//        apollo.perform(
//              mutation: AuthorizePaymentMutation( authorisePayment: authorizeInput)){ result in
//              switch result {
//                 case .success(let graphQLResult):
//                        if let paymentResult = graphQLResult.data?.authorizePayment { //reflect payment success
//                            if [.succeeded, .authorised].contains(paymentResult.status) {
//                                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//                            }
//                            print(paymentResult)
//                            controller.dismiss(animated: true, completion: nil)
//                        }
//                        
//                        if graphQLResult.errors != nil { //reflect api errors
//                            print(graphQLResult.errors as Any)
//                            completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
//                        }
//                  break
//                case .failure(let error): //reflect network errors
//                   print("Request failed! Error: \(error)")
//                   completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
//                  break
//                }
//            }
//    }
}
