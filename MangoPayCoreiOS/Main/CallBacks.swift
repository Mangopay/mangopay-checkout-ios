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
    var onCancelled: ((Error) -> Void)?
    var onError: ((Error) -> Void)?

    public init(
        onPayButtonClicked: ( (MGPCardInfo) -> Void)? = nil,
        onTokenizationCompleted: ( (MGPCardRegistration) -> Void)? = nil,
        onPaymentCompleted: ( () -> Void)? = nil,
        onCancelled: ((Error) -> Void)?,
        onError: ((Error) -> Void)? = nil
    ) {
        self.onPayButtonClicked = onPayButtonClicked
        self.onTokenizationCompleted = onTokenizationCompleted
        self.onPaymentCompleted = onPaymentCompleted
        self.onCancelled = onCancelled
        self.onError = onError
    }
}

//fun onPaymentMethodSelected(paymentMethod)
//fun onTokenizationCompleted()
//fun onPaymentCompleted()
//fun onError()
//fun onCancelled()
