//
//  File.swift
//  
//
//  Created by Elikem Savie on 09/11/2023.
//

import Foundation

public struct CardValidation: Codable, PayInPreAuthProtocol {

    public var authorID: String?
    public var tag: String?
    public var debitedFunds: DebitedFunds?
    public var secureMode: String?
    public var cardID: String?
    public var secureModeNeeded: Bool?
    public var secureModeRedirectURL: String?
    public var secureModeReturnURL: String?
    public var status: String?
    public var culture: String?
    public var ipAddress: String?
    public var browserInfo: BrowserInfo?

    enum CodingKeys: String, CodingKey {
        case tag = "Tag"
        case authorID = "AuthorId"
        case debitedFunds = "DebitedFunds"
        case culture = "Culture"
        case secureMode = "SecureMode"
        case cardID = "CardId"
        case secureModeReturnURL = "SecureModeReturnURL"
        case secureModeRedirectURL = "SecureModeRedirectURL"
        case browserInfo = "BrowserInfo"
        case ipAddress = "IpAddress"
        case secureModeNeeded = "SecureModeNeeded"
    }

    public init(authorID: String? = nil, tag: String? = nil, debitedFunds: DebitedFunds? = nil, secureMode: String? = nil, cardID: String? = nil, secureModeNeeded: Bool? = nil, secureModeRedirectURL: String? = nil, secureModeReturnURL: String? = nil, status: String? = nil, culture: String? = nil, ipAddress: String? = nil, browserInfo: BrowserInfo? = nil) {
        self.authorID = authorID
        self.tag = tag
        self.debitedFunds = debitedFunds
        self.secureMode = secureMode
        self.cardID = cardID
        self.secureModeNeeded = secureModeNeeded
        self.secureModeRedirectURL = secureModeRedirectURL
        self.secureModeReturnURL = secureModeReturnURL
        self.status = status
        self.culture = culture
        self.ipAddress = ipAddress
        self.browserInfo = browserInfo
    }
}

public struct Paypal: Codable {
    let authorID: String?
    let debitedFunds, fees: DebitedFunds?
    public let creditedWalletID, returnURL: String?, redirectURL: String?
    let shippingAddress: PPAddress?
    let tag, culture: String?
    let lineItems: [LineItem]?
    let shippingPreference: String?
    let reference: String?

    enum CodingKeys: String, CodingKey {
        case authorID = "AuthorId"
        case debitedFunds = "DebitedFunds"
        case fees = "Fees"
        case creditedWalletID = "CreditedWalletId"
        case returnURL = "ReturnURL"
        case redirectURL = "RedirectURL"
        case shippingAddress = "ShippingAddress"
        case tag = "Tag"
        case culture = "Culture"
        case lineItems = "LineItems"
        case shippingPreference = "ShippingPreference"
        case reference = "Reference"
    }

    public init(authorID: String?, debitedFunds: DebitedFunds?, fees: DebitedFunds?, creditedWalletID: String?, returnURL: String?, shippingAddress: PPAddress?, tag: String?, culture: String?, lineItems: [LineItem]?, shippingPreference: String?, reference: String?, redirectURL: String?) {
        self.authorID = authorID
        self.debitedFunds = debitedFunds
        self.fees = fees
        self.creditedWalletID = creditedWalletID
        self.returnURL = returnURL
        self.shippingAddress = shippingAddress
        self.tag = tag
        self.culture = culture
        self.lineItems = lineItems
        self.shippingPreference = shippingPreference
        self.reference = reference
        self.redirectURL = redirectURL
    }
}

public struct LineItem: Codable {
    let name: String
    let quantity, unitAmount, taxAmount: Int
    let description: String

    public init(name: String, quantity: Int, unitAmount: Int, taxAmount: Int, description: String) {
        self.name = name
        self.quantity = quantity
        self.unitAmount = unitAmount
        self.taxAmount = taxAmount
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case quantity = "Quantity"
        case unitAmount = "UnitAmount"
        case taxAmount = "TaxAmount"
        case description = "Description"
    }
}

public struct PPAddress: Codable {
    let recipientName: String?
    let address: Address?

    enum CodingKeys: String, CodingKey {
        case recipientName = "RecipientName"
        case address = "Address"
        
    }
    public init(recipientName: String?, address: Address?) {
        self.recipientName = recipientName
        self.address = address
    }
}
