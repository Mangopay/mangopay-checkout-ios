//
//  File.swift
//  
//
//  Created by Elikem Savie on 04/12/2022.
//

import Foundation

struct ApplePayTokenData: Codable {
    let data: String
    let signature: String
    let version: String
    let header: Header
    
    struct Header: Codable {
        let publicKeyHash: String
        let ephemeralPublicKey: String
        let transactionId: String
    }
}
