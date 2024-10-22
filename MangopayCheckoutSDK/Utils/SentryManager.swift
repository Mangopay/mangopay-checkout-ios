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
    case PAYMENT_METHOD_SELECTED = "Payment method selected"
    case THREE_AUTH_REQ = "3DS Authentication requested"
    case THREE_AUTH_COMPLETED = "3DS Authentication completed"
    case THREE_AUTH_FAILED = "3DS Authorization failed"
    case PAYMENT_COMPLETED = "Payment completed"
    case PAYMENT_FAILED = "Payment failed"
    case PAYMENT_CANCELLED = "Payment canceled"
    case PAYMENT_ERRORED = "Payment error"
    case NETHONE_PROFILER_INIT = "Nethone profiler initialized"
    case CARD_REGISTRATION_STARTED = "Card registration started"
    case CARD_REGISTRATION_COMPLETED = "Create card registration completed"
    case TOKENIZATION_COMPLETED = "Tokenization completed"
    case TOKENIZATION_FAILED = "Tokenization failed"
    case CARD_REGISTRATION_FAILED = "Create card registration failed"
    case APPLEPAY_INITIALIZED = "Apple Pay initialized"
    case PAYMENT_METHODS_RENDERED = "Payment methods rendered"
}


final public class SentryManager {

    static func initialize(
        environment: MGPEnvironment,
        clientId: String,
        checkoutReference: String,
        profillingMerchantId: String
    ) {
        SentrySDK.start { options in
            switch environment {
            case .sandbox, .t3:
                options.dsn = Constants.sentryDev
                options.releaseName = Constants.sdkVersion
                options.environment = "dev"
            case .production:
                options.dsn  = Constants.sentryProd
                options.releaseName = Constants.sdkVersion
                options.environment = "production"
            }

            options.debug  = false
        }
    
        SentrySDK.configureScope { scope in
            scope.setTag(value: clientId, key: "clientId")
            scope.setTag(value: checkoutReference, key: "checkoutReference")
            scope.setTag(value: profillingMerchantId, key: "profilingMerchantId")
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
