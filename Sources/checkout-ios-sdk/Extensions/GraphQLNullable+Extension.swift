//
//  File.swift
//  
//
//  Created by Elikem Savie on 02/11/2022.
//

import Foundation
import ApolloAPI
import Apollo

extension GraphQLNullable {
    static func makeString(_ text: String) -> GraphQLNullable<String> {
        return GraphQLNullable<String>(stringLiteral: text)
    }
}
