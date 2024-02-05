//
//  File.swift
//  
//
//  Created by Elikem Savie on 08/05/2023.
//

import Foundation

public struct AuthorizePayIn: Codable, PayInPreAuthProtocol {
    

    public var id, tag, authorID, creditedUserID: String?
    public var debitedFunds, fees: Amount?
    public var creditedWalletID, secureMode, cardID: String?
    public var secureModeReturnURL, secureModeRedirectURL: String?
    var statementDescriptor: String?
    var browserInfo: BrowserInfo?
    var ipAddress: String?
    var billing, shipping: Ing?
    public var secureModeNeeded: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case tag = "Tag"
        case authorID = "AuthorId"
        case creditedUserID = "CreditedUserId"
        case debitedFunds = "DebitedFunds"
        case fees = "Fees"
        case creditedWalletID = "CreditedWalletId"
        case secureMode = "SecureMode"
        case cardID = "CardId"
        case secureModeReturnURL = "SecureModeReturnURL"
        case secureModeRedirectURL = "SecureModeRedirectURL"
        case statementDescriptor = "StatementDescriptor"
        case browserInfo = "BrowserInfo"
        case ipAddress = "IpAddress"
        case billing = "Billing"
        case shipping = "Shipping"
        case secureModeNeeded = "SecureModeNeeded"
    }

    public init(
        tag: String? = nil,
        authorID: String,
        creditedUserID: String? = nil,
        debitedFunds: Amount,
        fees: Amount,
        creditedWalletID: String,
        secureMode: String? = nil,
        cardID: String,
        secureModeReturnURL: String,
        secureModeRedirectURL: String? = nil,
        statementDescriptor: String,
        browserInfo: BrowserInfo? = nil,
        ipAddress: String,
        billing: Ing? = nil,
        shipping: Ing? = nil,
        secureModeNeeded: Bool? = false
    ) {
        self.tag = tag
        self.authorID = authorID
        self.creditedUserID = creditedUserID
        self.debitedFunds = debitedFunds
        self.fees = fees
        self.creditedWalletID = creditedWalletID
        self.secureMode = secureMode
        self.cardID = cardID
        self.secureModeReturnURL = secureModeReturnURL
        self.secureModeRedirectURL = secureModeRedirectURL
        self.statementDescriptor = statementDescriptor
        self.browserInfo = browserInfo
        self.ipAddress = ipAddress
        self.billing = billing
        self.shipping = shipping
        self.secureModeNeeded = secureModeNeeded
    }

}

public struct Ing: Codable {
    var firstName, lastName: String?
    var address: Address?

    public init(firstName: String? = nil, lastName: String? = nil, address: Address? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
    }
    enum CodingKeys: String, CodingKey {
        case firstName = "FirstName"
        case lastName = "LastName"
        case address = "Address"
    }
}

public struct Address: Codable {
    var addressLine1, addressLine2, city, region: String?
    var postalCode, country: String?

    enum CodingKeys: String, CodingKey {
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case city = "City"
        case region = "Region"
        case postalCode = "PostalCode"
        case country = "Country"
    }

    public init(addressLine1: String? = nil, addressLine2: String? = nil, city: String? = nil, region: String? = nil, postalCode: String? = nil, country: String? = nil) {
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.region = region
        self.postalCode = postalCode
        self.country = country
    }
}


public struct BrowserInfo: Codable {
    var acceptHeader: String?
    var javaEnabled: Bool?
    var language: String?
    var colorDepth, screenHeight, screenWidth, timeZoneOffset: Int?
    var userAgent: String?
    var javascriptEnabled: Bool?

    public init(
        acceptHeader: String? = "text/html, application/xhtml+xml, application/xml;q=0.9, /;q=0.8",
        javaEnabled: Bool? = true,
        language: String? = "FR-FR",
        colorDepth: Int? = 4,
        screenHeight: Int? = 1800,
        screenWidth: Int? = 400,
        timeZoneOffset: Int? = 60,
        userAgent: String? =  "Mozilla/5.0 (iPhone; CPU iPhone OS 13_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
        javascriptEnabled: Bool? = true
    ) {
        self.acceptHeader = acceptHeader
        self.javaEnabled = javaEnabled
        self.language = language
        self.colorDepth = colorDepth
        self.screenHeight = screenHeight
        self.screenWidth = screenWidth
        self.timeZoneOffset = timeZoneOffset
        self.userAgent = userAgent
        self.javascriptEnabled = javascriptEnabled
    }

    enum CodingKeys: String, CodingKey {
        case acceptHeader = "AcceptHeader"
        case javaEnabled = "JavaEnabled"
        case language = "Language"
        case colorDepth = "ColorDepth"
        case screenHeight = "ScreenHeight"
        case screenWidth = "ScreenWidth"
        case timeZoneOffset = "TimeZoneOffset"
        case userAgent = "UserAgent"
        case javascriptEnabled = "JavascriptEnabled"
    }
}

public struct Amount: Codable {
    var currency: String?
    var amount: Int?

    enum CodingKeys: String, CodingKey {
        case currency = "Currency"
        case amount = "Amount"
    }

    public init(currency: String? = nil, amount: Int? = nil) {
        self.currency = currency
        self.amount = amount
    }

}
