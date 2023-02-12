//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/10/2022.
//

import Foundation
import Apollo
import ApolloAPI

public class TokenInterceptor: ApolloInterceptor {

    let token: String
    let indempodentKey: String

    public init(token: String, indempodentKey: String) {
        self.token = token
        self.indempodentKey = indempodentKey
    }

    public func interceptAsync<Operation>(
        chain: Apollo.RequestChain,
        request: Apollo.HTTPRequest<Operation>,
        response: Apollo.HTTPResponse<Operation>?,
        completion: @escaping (Result<Apollo.GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : ApolloAPI.GraphQLOperation {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
            request.addHeader(name: "X-Idempotency-Key", value: indempodentKey)
            chain.proceedAsync(request: request, response: response, completion: completion)
        }
}
