//
//  File.swift
//  
//
//  Created by Elikem Savie on 03/07/2023.
//

import Foundation
import MangoPaySdkAPI

public struct CallBack {
    var onPayButtonClicked: ((MGPCardInfo) -> Void)?
    var onTokenizationCompleted: ((MGPCardRegistration) -> Void)?
    var onPaymentCompleted: (() -> Void)?
    var onError: ((Error) -> Void)?

    public init(
        onPayButtonClicked: ( (MGPCardInfo) -> Void)? = nil,
        onTokenizationCompleted: ( (MGPCardRegistration) -> Void)? = nil,
        onPaymentCompleted: ( () -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) {
        self.onPayButtonClicked = onPayButtonClicked
        self.onTokenizationCompleted = onTokenizationCompleted
        self.onPaymentCompleted = onPaymentCompleted
        self.onError = onError
    }
}
