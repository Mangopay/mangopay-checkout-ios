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

    public var id: String {
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
    case CANCELLED
}

public struct _3DSResult: Codable {
    public let type: _3DSTransactionType
    public let status: _3DSStatus
    public let id: String
    public var nethoneAttemptReference: String?

}
