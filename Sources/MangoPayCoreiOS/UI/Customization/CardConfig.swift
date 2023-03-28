//
//  File.swift
//  
//
//  Created by Elikem Savie on 27/10/2022.
//

import Foundation

public struct CardConfig {
    public var supportedCardBrands: [CardType]?
    
    public init(supportedCardBrands: [CardType]? = nil) {
        self.supportedCardBrands = supportedCardBrands
    }
}
