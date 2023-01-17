//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation

struct Country: Codable {

    let code: String
    let emoji: String
    let name: String
    let dialCode: String?
    
    enum CodingKeys: CodingKey {
        case code, emoji, name, dialCode
    }

    var nameAndFlag: String? {
        return " \(emoji) \(name)"
    }

    var displayableTitle: String {
        return "\(emoji) \(code ?? "")"
    }

}
