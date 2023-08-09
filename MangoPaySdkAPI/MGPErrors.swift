//
//  File.swift
//  
//
//  Created by Elikem Savie on 31/07/2023.
//

import Foundation

public enum MGPError: Error {
    case invalidForm
    case nethoneAttemptReferenceRqd
    case cardRegistrationNotSet
    case initializationRqd
    case tokenizationError(additionalInfo: String?)

    public var reason: String {
        switch self {
        case .invalidForm:
            return "Some Form fields are invalid"
        case .nethoneAttemptReferenceRqd:
            return "Nethone reference required"
        case .cardRegistrationNotSet:
            return "Card Registration Object not set"
        case .initializationRqd:
            return "SDK initialisation not set, kindly call MGPPegasus.initialize"
        case .tokenizationError(let errorStr):
            return "Tokenisation Error \(errorStr ?? "")"
        }
    }
}
