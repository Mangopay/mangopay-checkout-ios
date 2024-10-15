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

    static func initialize(
        environment: MGPEnvironment,
        clientId: String,
        checkoutReference: String
    ) {
        SentrySDK.start { options in
            switch environment {
            case .sandbox, .t3:
                options.dsn = Constants.sentryDev
                options.releaseName = "1.1.3"
                options.environment = "dev"
            case .production:
                options.dsn  = Constants.sentryProd
                options.releaseName = "1.1.3"
                options.environment = "production"
            }

            options.debug  = false
        }
    
        SentrySDK.configureScope { scope in
            scope.setTag(value: clientId, key: "clientid")
            scope.setTag(value: checkoutReference, key: "checkoutReference")
        }
    }

    static func log(
        name: MGPEvent,
        metadata: [String: String]? = nil,
        tags: [String: String]? = nil
    ) {
        SentrySDK.capture(message: name.rawValue) { scope in
            guard let _tags = tags else { return }
            for (key, value) in _tags {
                scope.setTag(value: value, key: key)
            }
        }

        if let _data = metadata {
            let crumb = Breadcrumb()
            crumb.level = SentryLevel.info
            crumb.category = "logs"
            crumb.message = name.rawValue
            crumb.data = metadata
            SentrySDK.addBreadcrumb(crumb)
        }
    }

    static func log(error: Error) {
        SentrySDK.capture(error: error)
    }

}
