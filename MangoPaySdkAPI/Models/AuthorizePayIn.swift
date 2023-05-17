//
//  File.swift
//  
//
//  Created by Elikem Savie on 08/05/2023.
//

import Foundation

public struct AuthorizePayIn: Codable {

    var tag, authorID, creditedUserID: String?
    var debitedFunds, fees: DebitedFunds?
    var creditedWalletID, secureMode, cardID: String?
    var secureModeReturnURL, secureModeRedirectURL: String?
    var statementDescriptor: String?
    var browserInfo: BrowserInfo?
    var ipAddress: String?
    var billing, shipping: Ing?

    enum CodingKeys: String, CodingKey {
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
    }

    public init(
        tag: String? = nil,
        authorID: String,
        creditedUserID: String? = nil,
        debitedFunds: DebitedFunds,
        fees: DebitedFunds,
        creditedWalletID: String,
        secureMode: String? = nil,
        cardID: String,
        secureModeReturnURL: String? = nil,
        secureModeRedirectURL: String? = nil,
        statementDescriptor: String,
        browserInfo: BrowserInfo? = nil,
        ipAddress: String? = nil,
        billing: Ing? = nil,
        shipping: Ing? = nil
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
    }

}

public struct Ing: Codable {
    var firstName, lastName: String?
    var address: Address?

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
}


public struct BrowserInfo: Codable {
    var acceptHeader: String?
    var javaEnabled: Bool?
    var language: String?
    var colorDepth, screenHeight, screenWidth, timeZoneOffset: Int?
    var userAgent: String?
    var javascriptEnabled: Bool?

    public init(acceptHeader: String? = nil, javaEnabled: Bool? = nil, language: String? = nil, colorDepth: Int? = nil, screenHeight: Int? = nil, screenWidth: Int? = nil, timeZoneOffset: Int? = nil, userAgent: String? = nil, javascriptEnabled: Bool? = nil) {
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

public struct DebitedFunds: Codable {
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
