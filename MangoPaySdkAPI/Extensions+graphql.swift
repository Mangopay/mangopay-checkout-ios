//
//  File.swift
//  
//
//  Created by Elikem Savie on 03/05/2023.
//

import Foundation
import Apollo
#if !COCOAPODS
import ApolloAPI
#endif

extension GraphQLNullable {
    static func makeString(_ text: String) -> GraphQLNullable<String> {
        return GraphQLNullable<String>(stringLiteral: text)
    }
}

extension String {
    public func toGraphQLNullable() -> GraphQLNullable<String> {
        return GraphQLNullable<String>(stringLiteral: self)
    }
}

extension Int {
    public func toGraphQLNullable() -> GraphQLNullable<Int> {
        return GraphQLNullable<Int>(integerLiteral: self)
    }
}

extension Bool {
    public func toGraphQLNullable() -> GraphQLNullable<Bool> {
        return GraphQLNullable<Bool>(booleanLiteral: self)
    }
}
