//
//  File.swift
//  
//
//  Created by Elikem Savie on 21/03/2024.
//

import Foundation
import Sentry


enum MGPEvent: String {
    case SDK_INITIALIZED
    case PAYMENT_METHOD_SELECTED
    case THREE_AUTH_REQ = "3DS_AUTHENTICATION_REQUESTED"
    case THREE_AUTH_COMPLETED = "3DS_AUTHENTICATION_COMPLETED"
    case THREE_AUTH_FAILED = "3DS_AUTHENTICATION_FAILED"
    case PAYMENT_COMPLETED = "PAYMENT_COMPLETED"
    case PAYMENT_FAILED = "PAYMENT_FAILED"
    case PAYMENT_CANCELLED = "PAYMENT_CANCELLED"
    case PAYMENT_ERRORED = "PAYMENT_ERRORED"
    case NETHONE_PROFILER_INIT = "NETHONE_PROFILER_INIT"
    case CARD_REGISTRATION_STARTED = "CARD_REGISTRATION_STARTED"
    case CARD_REGISTRATION_COMPLETED = "CARD_REGISTRATION_COMPLETED"
    case CARD_REGISTRATION_FAILED = "CARD_REGISTRATION_FAILED"
    case APPLEPAY_INITIALIZED = "APPLEPAY_INITIALIZED"
    case PAYMENT_METHODS_RENDERED = "PAYMENT_METHODS_RENDERED"
}


final public class SentryManager {

    static func initialize() {
        SentrySDK.start { options in
            options.dsn  = "https://61b32fa858ecb972d966bf2a9bdb1dff@o4506778679181312.ingest.us.sentry.io/4506863051603969"
            options.debug  = false
        }
    }

    static func log(name: MGPEvent) {
        SentrySDK.capture(message: name.rawValue)
    }

}
