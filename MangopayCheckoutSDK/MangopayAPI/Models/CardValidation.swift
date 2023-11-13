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
