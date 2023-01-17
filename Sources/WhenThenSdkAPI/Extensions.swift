//
//  File.swift
//  
//
//  Created by Elikem Savie on 17/01/2023.
//

import Foundation
import ApolloAPI
import Apollo

extension GraphQLNullable {
    static func makeString(_ text: String) -> GraphQLNullable<String> {
        return GraphQLNullable<String>(stringLiteral: text)
    }
}

extension UUID {

    var version1UUID: String {
        var uuid: uuid_t = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
        withUnsafeMutablePointer(to: &uuid) {
            $0.withMemoryRebound(to: UInt8.self, capacity: 16) {
                uuid_generate_time($0)
            }
        }

        let finalUUID = UUID(uuid: uuid)
        return finalUUID.uuidString
    }

}

extension String {
    
    func isMatch(_ Regex: String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: Regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }.count > 0
        } catch {
            return false
        }
        
    }
    
    func fromBase64() -> String {
        let base64Decode = Data(base64Encoded: self)!
        return String(data: base64Decode, encoding: .utf8)!
    }
}

extension String {
    func toGraphQLNullable() -> GraphQLNullable<String> {
        return GraphQLNullable<String>(stringLiteral: self)
    }
}
