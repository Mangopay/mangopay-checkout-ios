//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/05/2023.
//

import Foundation

public struct PayInCard: Codable {
    var expirationDate, alias, cardType, cardProvider: String?
    var country, product, bankCode: String?
    var active: Bool?
    var currency, validity, userID: String?
    public var id: String?
    var tag: String?
    var creationDate: Int?
    var fingerprint: String?

    enum CodingKeys: String, CodingKey {
        case expirationDate = "ExpirationDate"
        case alias = "Alias"
        case cardType = "CardType"
        case cardProvider = "CardProvider"
        case country = "Country"
        case product = "Product"
        case bankCode = "BankCode"
        case active = "Active"
        case currency = "Currency"
        case validity = "Validity"
        case userID = "UserId"
        case id = "Id"
        case tag = "Tag"
        case creationDate = "CreationDate"
        case fingerprint = "Fingerprint"
    }
}
