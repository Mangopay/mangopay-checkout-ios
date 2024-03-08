//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation

public struct CallBack {
    var onPaymentMethodSelected: ((PaymentMethod) -> Void)?
    var onTokenizationCompleted: ((TokenizedCardData) -> Void)?
    var onCreateCardRegistration: ((MGPCardInfo) async -> MGPCardRegistration?)?
    var onPaymentCompleted: ((String?, _3DSResult?) -> Void)?
    var onCreatePayment: ((PaymentMethod, String?) async -> Payable?)?
    var onCancel: (() -> Void)?
    var onError: ((MGPError) -> Void)?

    public init(
        onPaymentMethodSelected: ((PaymentMethod) -> Void)? = nil,
        onTokenizationCompleted: ( (TokenizedCardData) -> Void)? = nil,
        onCreateCardRegistration: ((MGPCardInfo) async -> MGPCardRegistration?)? = nil,
        onPaymentCompleted: ((String?, _3DSResult?) -> Void)? = nil,
        onCreatePayment: ((PaymentMethod, String?) async -> Payable?)? = nil,
        onCancelled: (() -> Void)?,
        onError: ((MGPError) -> Void)? = nil
    ) {
        self.onPaymentMethodSelected = onPaymentMethodSelected
        self.onTokenizationCompleted = onTokenizationCompleted
        self.onCreateCardRegistration = onCreateCardRegistration
        self.onCreatePayment = onCreatePayment
        self.onPaymentCompleted = onPaymentCompleted
        self.onCancel = onCancelled
        self.onError = onError
    }
}
