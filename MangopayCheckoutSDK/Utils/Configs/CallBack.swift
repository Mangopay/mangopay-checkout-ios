//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation

public struct CallBack {
    var onPaymentMethodSelected: ((PaymentMethod) async -> APMInfo?)?
    var onTokenizationCompleted: ((MGPCardRegistration) -> Void)?
    var onPaymentCompleted: ((String?, _3DSResult?) -> Void)?
    var onCancelled: (() -> Void)?
    var onError: ((MGPError) -> Void)?
    var onSheetDismissed: (() -> Void)?

    public init(
        onPaymentMethodSelected: ((PaymentMethod) async -> APMInfo?)? = nil,
        onTokenizationCompleted: ( (MGPCardRegistration) -> Void)? = nil,
        onPaymentCompleted: ((String?, _3DSResult?) -> Void)? = nil,
        onCancelled: (() -> Void)?,
        onError: ((MGPError) -> Void)? = nil,
        onSheetDismissed: (() -> Void)? = nil
    ) {
        self.onPaymentMethodSelected = onPaymentMethodSelected
        self.onTokenizationCompleted = onTokenizationCompleted
        self.onPaymentCompleted = onPaymentCompleted
        self.onCancelled = onCancelled
        self.onError = onError
        self.onSheetDismissed = onSheetDismissed
    }
}
