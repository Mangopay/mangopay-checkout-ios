//
//  File.swift
//  
//
//  Created by Elikem Savie on 04/10/2023.
//

import Foundation

public enum _3DSTransactionType: String, Codable {
    case cardDirect = "CARD_DIRECT"
    case preauthorized = "PREAUTHORIZED"
    case cardValidated = "CARD_VALIDATION"

    var id: String {
        switch self {
        case .cardDirect:
            return "transactionId"
        case .preauthorized:
            return "preAuthorizationId"
        case .cardValidated:
            return "cardValidationId"
        }
    }
}

public enum _3DSStatus: String, Codable {
    case SUCCEEDED
    case FAILED
}

public struct _3DSResult: Codable {
    let type: _3DSTransactionType
    let status: _3DSStatus
    let id: String
}
