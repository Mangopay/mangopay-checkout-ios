//
//  File.swift
//  
//
//  Created by Elikem Savie on 04/10/2022.
//

import Foundation
import Apollo
import ApolloAPI
import SchemaPackage

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

    func fetch() {
        let errors = [Error]()
        
        let authorizeInput = AuthorisedPaymentInput(
            orderId: "1321313",
            intentId: "dcc232 3323",
            paymentMethod: PaymentMethodDtoInput(
            type: "APPLE_PAY",
            walletToken: "token")
        )
        
        var token = fromBase64(word: "payment.token.paymentData.base64EncodedString()")
        token = "{ \"paymentData\": \(token) }" //wrap token in paymentData object

        //let token = readLocalFile(forName: "ApplePayToken")!; //use local token
        
        //build the graphql request with token
//        let authorizeInput = AuthorisedPaymentInput(
//                        orderId: "xxxxx-orderId",
//                        flowId: ";knlknn",
//                        paymentMethod: PaymentMethodDtoInput(
//                            type: "APPLE_PAY",
//                            walletToken: token)
//                        )
        print("🤣 fetxhing...")
        apollo.perform(
              mutation: AuthorizePaymentMutation( authorisePayment: authorizeInput)) { result in
              switch result {
                 case .success(let graphQLResult):
                        if let paymentResult = graphQLResult.data?.authorizePayment { //reflect payment success
                            if [.succeeded, .authorised].contains(paymentResult.status) {
//                                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                            }
                            print(paymentResult)
                        }
                        
                        if graphQLResult.errors != nil { //reflect api errors
                            print(graphQLResult.errors as Any)
                        }
                  break
                case .failure(let error): //reflect network errors
                   print("Request failed! Error: \(error)")
//                   completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
                  break
                }
            }
    }

    func fromBase64(word: String ) -> String {
        let base64Decode = Data(base64Encoded: word)!
        return String(data: base64Decode, encoding: .utf8)!
    }

    func fetchCards() {
        let query = ListCustomerCardsQuery(vaultCustomerId: "a4a7cb68-9ce6-4874-84df-276d7e9b235b")
        apollo.fetch(query: query, resultHandler: { response
            switch response {

            }
        })
    }
}

fetch()
