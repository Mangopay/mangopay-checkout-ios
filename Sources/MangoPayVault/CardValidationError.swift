//
//  File.swift
//  
//
//  Created by Elikem Savie on 03/03/2023.
//

import Foundation


public enum CardValidationError: Error {
    
    case cardNumberRqd
    case cardNumberInvalid
    case expDateRqd
    case expDateInvalid
    case cvvRqd
    case cvvInvalid

    var reason: String {
        switch self {
        case .cardNumberRqd:
            return "Card Number Required"
        case .cardNumberInvalid:
            return "Card Number Invalid"
        case .expDateRqd:
            return "Expiration Date Required"
        case .expDateInvalid:
            return "Expiration Date Invalid"
        case .cvvRqd:
            return "CVV Required"
        case .cvvInvalid:
            return "CVV Invalid"
        }
    }
}
