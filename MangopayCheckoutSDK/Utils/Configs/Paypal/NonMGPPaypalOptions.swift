//
//  File.swift
//  
//
//  Created by Elikem Savie on 02/07/2024.
//

import Foundation
import PayPal

public struct NonMGPPaypalOptions {
    var color: PayPalButton.Color = .gold
    var edges: PaymentButtonEdges = .softEdges
    var label: PayPalButton.Label?

    public init(
        color: PayPalButton.Color? = .gold,
        edges: PaymentButtonEdges? = .softEdges,
        label: PayPalButton.Label? = nil
    ) {
        self.color = color ?? .gold
        self.edges = edges ?? .softEdges
        self.label = label
    }

}
