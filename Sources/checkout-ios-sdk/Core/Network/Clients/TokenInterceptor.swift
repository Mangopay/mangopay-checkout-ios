//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/10/2022.
//

import Foundation
import Apollo
import ApolloAPI

class TokenInterceptor: ApolloInterceptor {

    let token: String

    init(token: String) {
        self.token = token
    }

    func interceptAsync<Operation>(
        chain: Apollo.RequestChain,
        request: Apollo.HTTPRequest<Operation>,
        response: Apollo.HTTPResponse<Operation>?,
        completion: @escaping (Result<Apollo.GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : ApolloAPI.GraphQLOperation {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
            chain.proceedAsync(request: request, response: response, completion: completion)
            print("🤣 Additional Headers", request.additionalHeaders)
        }
    
}
