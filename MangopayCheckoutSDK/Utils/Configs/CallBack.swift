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
    var onPaymentCompleted: ((String?, _3DSResult?) -> Void)?
    var onProcessPayment: ((PaymentMethod) async -> APMInfo?)?
    var onCreatePayment: (() async -> PayInPreAuthProtocol?)?  
    var onCreateCardRegistration: ((MGPCardInfo) async -> MGPCardRegistration?)?
    var onCancel: (() -> Void)?
    var onError: ((MGPError) -> Void)?
    var onSheetDismissed: (() -> Void)?

    public init(
        onPaymentMethodSelected: ((PaymentMethod) -> Void)? = nil,
        onTokenizationCompleted: ( (TokenizedCardData) -> Void)? = nil,
        onPaymentCompleted: ((String?, _3DSResult?) -> Void)? = nil,
        onProcessPayment: ((PaymentMethod) async -> APMInfo?)? = nil,
        onCreatePayment: (() async -> PayInPreAuthProtocol?)? = nil,
        onCreateCardRegistration: ((MGPCardInfo) async -> MGPCardRegistration?)? = nil,
        onCancelled: (() -> Void)?,
        onError: ((MGPError) -> Void)? = nil,
        onSheetDismissed: (() -> Void)? = nil
    ) {
        self.onPaymentMethodSelected = onPaymentMethodSelected
        self.onTokenizationCompleted = onTokenizationCompleted
        self.onProcessPayment = onProcessPayment
        self.onCreateCardRegistration = onCreateCardRegistration
        self.onCreatePayment = onCreatePayment
        self.onPaymentCompleted = onPaymentCompleted
        self.onCancel = onCancelled
        self.onError = onError
        self.onSheetDismissed = onSheetDismissed
    }
}
