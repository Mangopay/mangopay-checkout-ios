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
    case _3dsNotRqd
    case _3dsPayInDataRqd
    case _3dsPresentingVCRqd
    case _3dsSecureURLRqd
    case _3dsUserFailedChallenge(reaon: String?)
    case _3dsError(additionalInfo: String?)
    case applePayErrorMerchantIdEmpty
    case applePayErrorCurrencyCode
    case applePayErrorCountryCode
    case applePayErrorAmount
    case applePayErrorNotSupported

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
        case ._3dsNotRqd:
            return "_3dsNotRqd"
        case ._3dsPayInDataRqd:
            return "PayIn Object required for 3DS"
        case ._3dsPresentingVCRqd:
            return "Presenting ViewcController required for 3DS"
        case ._3dsSecureURLRqd:
            return "secureModeRedirectURL cannot be nil"
        case ._3dsUserFailedChallenge(let errorStr):
            return "User failed 3DS challenge \(errorStr ?? "")"
        case ._3dsError(let errorStr):
            return "3DS Error: \(errorStr ?? "")"
        case .applePayErrorMerchantIdEmpty:
            return "ApplePay MerchantIdentifier is empty"
        case .applePayErrorCurrencyCode:
            return "ApplePay Currency Code is empty"
        case .applePayErrorCountryCode:
            return "ApplePay Country Code is empty"
        case .applePayErrorAmount:
            return "ApplePay amount cannot be nil"
        case .applePayErrorNotSupported:
            return "ApplePay not supported for this device"
        }
    }
}
