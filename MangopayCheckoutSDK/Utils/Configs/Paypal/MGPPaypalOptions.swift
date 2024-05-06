//
//  File.swift
//  
//
//  Created by Elikem Savie on 14/12/2023.
//

import Foundation
import PaymentButtons

public struct MGPPaypalOptions {
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
