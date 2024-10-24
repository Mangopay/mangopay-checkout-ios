//
//  File.swift
//  
//
//  Created by Elikem Savie on 26/02/2023.
//

import Foundation
import MangopayVaultSDK

public enum MGPEnvironment: String, CaseIterable {
    case sandbox
    case production
    case t3

    public var url: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://api.sandbox.mangopay.com")!
        case .production:
            return URL(string: "https://api.mangopay.com")!
        case .t3:
            return URL(string: "https://testing3-api.mangopay.com")!
        }
    }
}

public struct MGPCardRegistration: Codable {
    
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
    public var currency, status, resultCode: String?
    
    public var registrationURL: URL? {
        guard let urlStr = cardRegistrationURLStr else { return nil }
        return URL(string: urlStr)
    }

    public var toVaultCardReg: CardRegistration {
        return CardRegistration(
            id: self.id,
            tag: self.tag,
            creationDate: self.creationDate,
            userID: self.userID,
            accessKey: self.accessKey,
            preregistrationData: self.preregistrationData,
            registrationData: self.registrationData,
            cardID: self.cardID,
            cardType: self.cardType,
            cardRegistrationURLStr: self.cardRegistrationURLStr,
            currency: self.currency,
            status: self.status,
            resultCode: self.resultCode
        )
    }

    public init(id: String? = nil, tag: String? = nil, creationDate: Int? = nil, userID: String? = nil, accessKey: String? = nil, preregistrationData: String? = nil, registrationData: String? = nil, cardID: String? = nil, cardType: String? = nil, cardRegistrationURLStr: String? = nil, currency: String? = nil, status: String? = nil, resultCode: String? = nil) {
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
        self.currency = currency
        self.status = status
        self.resultCode = resultCode
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
        case currency = "Currency"
        case status = "Status"
        case resultCode = "ResultCode"
    }
}

extension CardRegistration {

    public var toMGPCardReg: MGPCardRegistration {
        return MGPCardRegistration(
            id: self.id,
            tag: self.tag,
            creationDate: self.creationDate,
            userID: self.userID,
            accessKey: self.accessKey,
            preregistrationData: self.preregistrationData,
            registrationData: self.registrationData,
            cardID: self.cardID,
            cardType: self.cardType,
            cardRegistrationURLStr: self.cardRegistrationURLStr,
            currency: self.currency,
            status: self.status,
            resultCode: self.resultCode
        )
    }
}
