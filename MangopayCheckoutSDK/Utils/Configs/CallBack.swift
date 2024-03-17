//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation

public struct CallBack {
    var onPaymentMethodSelected: ((PaymentMethod) async -> APMInfo?)?
    var onTokenizationCompleted: ((TokenizedCardData) -> Void)?
    var onPaymentCompleted: ((String?, _3DSResult?) -> Void)?
    var onCancel: (() -> Void)?
    var onError: ((MGPError) -> Void)?
    var onSheetDismissed: (() -> Void)?

    public init(
        onPaymentMethodSelected: ((PaymentMethod) async -> APMInfo?)? = nil,
        onTokenizationCompleted: ( (TokenizedCardData) -> Void)? = nil,
        onPaymentCompleted: ((String?, _3DSResult?) -> Void)? = nil,
        onCancel: (() -> Void)?,
        onError: ((MGPError) -> Void)? = nil,
        onSheetDismissed: (() -> Void)? = nil
    ) {
        self.onPaymentMethodSelected = onPaymentMethodSelected
        self.onTokenizationCompleted = onTokenizationCompleted
        self.onPaymentCompleted = onPaymentCompleted
        self.onCancel = onCancel
        self.onError = onError
        self.onSheetDismissed = onSheetDismissed
    }
}
