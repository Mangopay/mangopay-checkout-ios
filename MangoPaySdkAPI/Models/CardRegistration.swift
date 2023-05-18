//
//  File.swift
//  
//
//  Created by Elikem Savie on 26/02/2023.
//

import Foundation

public enum Environment: String {
    case sandbox
    case prod

    public var url: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://api.sandbox.mangopay.com")!
        case .prod:
            return URL(string: "https://api.mangopay.com")!
        }
    }
}

public struct CardRegistration: Codable {
    
    public struct Initiate: Codable {
        var UserId: String
        var Currency: String
        var CardType: String

        public init(UserId: String, Currency: String, CardType: String) {
            self.UserId = UserId
            self.Currency = Currency
            self.CardType = CardType
        }
    }

    public var id, tag, userID: String?
    public var creationDate: Int?
    public var accessKey, preregistrationData, registrationData, cardID: String?
    public var cardType: String?
    public var cardRegistrationURLStr: String?
    public var resultCode, resultMessage, currency, status: String?
    
    public var registrationURL: URL? {
        guard let urlStr = cardRegistrationURLStr else { return nil }
        return URL(string: urlStr)
    }

    public init(id: String? = nil, tag: String? = nil, creationDate: Int? = nil, userID: String? = nil, accessKey: String? = nil, preregistrationData: String? = nil, registrationData: String? = nil, cardID: String? = nil, cardType: String? = nil, cardRegistrationURLStr: String? = nil, resultCode: String? = nil, resultMessage: String? = nil, currency: String? = nil, status: String? = nil) {
        self.id = id
        self.tag = tag
        self.creationDate = creationDate
        self.userID = userID
        self.accessKey = accessKey
        self.preregistrationData = preregistrationData
        self.registrationData = registrationData
        self.cardID = cardID
        self.cardType = cardType
        self.cardRegistrationURLStr = cardRegistrationURLStr
        self.resultCode = resultCode
        self.resultMessage = resultMessage
        self.currency = currency
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case tag = "Tag"
        case creationDate = "CreationDate"
        case userID = "UserId"
        case accessKey = "AccessKey"
        case preregistrationData = "PreregistrationData"
        case registrationData = "RegistrationData"
        case cardID = "CardId"
        case cardType = "CardType"
        case cardRegistrationURLStr = "CardRegistrationURL"
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case currency = "Currency"
        case status = "Status"
    }
}

