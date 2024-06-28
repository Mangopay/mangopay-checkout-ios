//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/05/2023.
//

import Foundation

public enum PayinStatus: String {
    case success = "SUCCEEDED"
    case failed = "FAILED"
}

public struct PayIn: Codable, Payable {
    
    var id, tag: String?
    var creationDate: Int?
    public var authorID, creditedUserID: String?
    public var debitedFunds, creditedFunds, fees: Amount?
    public var status, resultCode, resultMessage: String?
    var executionDate: Int?
    var type, nature, creditedWalletID: String?
    var debitedWalletID: String?
    public var paymentType, executionType, secureMode, cardID: String?
    public var secureModeReturnURL, secureModeRedirectURL: String?
    public var secureModeNeeded: Bool?
    var culture: String?
    var securityInfo: SecurityInfo?
    var statementDescriptor: String?
    var browserInfo: BrowserInfo?
    var ipAddress: String?
    var billing, shipping: Ing?
    var requested3DSVersion, applied3DSVersion, recurringPayinRegistrationID: String?
    

    public var statusenum: PayinStatus? {
        guard let str = status else { return nil }
        return PayinStatus(rawValue: str)
    }

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case tag = "Tag"
        case creationDate = "CreationDate"
        case authorID = "AuthorId"
        case creditedUserID = "CreditedUserId"
        case debitedFunds = "DebitedFunds"
        case creditedFunds = "CreditedFunds"
        case fees = "Fees"
        case status = "Status"
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case executionDate = "ExecutionDate"
        case type = "Type"
        case nature = "Nature"
        case creditedWalletID = "CreditedWalletId"
        case debitedWalletID = "DebitedWalletId"
        case paymentType = "PaymentType"
        case executionType = "ExecutionType"
        case secureMode = "SecureMode"
        case cardID = "CardId"
        case secureModeReturnURL = "SecureModeReturnURL"
        case secureModeRedirectURL = "SecureModeRedirectURL"
        case secureModeNeeded = "SecureModeNeeded"
        case culture = "Culture"
        case securityInfo = "SecurityInfo"
        case statementDescriptor = "StatementDescriptor"
        case browserInfo = "BrowserInfo"
        case ipAddress = "IpAddress"
        case billing = "Billing"
        case shipping = "Shipping"
        case requested3DSVersion = "Requested3DSVersion"
        case applied3DSVersion = "Applied3DSVersion"
        case recurringPayinRegistrationID = "RecurringPayinRegistrationId"
    }

    public init(id: String? = nil, tag: String? = nil, creationDate: Int? = nil, authorID: String? = nil, creditedUserID: String? = nil, debitedFunds: Amount? = nil, creditedFunds: Amount? = nil, fees: Amount? = nil, status: String? = nil, resultCode: String? = nil, resultMessage: String? = nil, executionDate: Int? = nil, type: String? = nil, nature: String? = nil, creditedWalletID: String? = nil, debitedWalletID: String? = nil, paymentType: String? = nil, executionType: String? = nil, secureMode: String? = nil, cardID: String? = nil, secureModeReturnURL: String? = nil, secureModeRedirectURL: String? = nil, secureModeNeeded: Bool? = nil, culture: String? = nil, securityInfo: SecurityInfo? = nil, statementDescriptor: String? = nil, browserInfo: BrowserInfo? = nil, ipAddress: String? = nil, billing: Ing? = nil, shipping: Ing? = nil, requested3DSVersion: String? = nil, applied3DSVersion: String? = nil, recurringPayinRegistrationID: String? = nil) {
        self.id = id
        self.tag = tag
        self.creationDate = creationDate
        self.authorID = authorID
        self.creditedUserID = creditedUserID
        self.debitedFunds = debitedFunds
        self.creditedFunds = creditedFunds
        self.fees = fees
        self.status = status
        self.resultCode = resultCode
        self.resultMessage = resultMessage
        self.executionDate = executionDate
        self.type = type
        self.nature = nature
        self.creditedWalletID = creditedWalletID
        self.debitedWalletID = debitedWalletID
        self.paymentType = paymentType
        self.executionType = executionType
        self.secureMode = secureMode
        self.cardID = cardID
        self.secureModeReturnURL = secureModeReturnURL
        self.secureModeRedirectURL = secureModeRedirectURL
        self.secureModeNeeded = secureModeNeeded
        self.culture = culture
        self.securityInfo = securityInfo
        self.statementDescriptor = statementDescriptor
        self.browserInfo = browserInfo
        self.ipAddress = ipAddress
        self.billing = billing
        self.shipping = shipping
        self.requested3DSVersion = requested3DSVersion
        self.applied3DSVersion = applied3DSVersion
        self.recurringPayinRegistrationID = recurringPayinRegistrationID
    }
}

// MARK: - CreditedFunds
public struct CreditedFunds: Codable {
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

// MARK: - SecurityInfo
public struct SecurityInfo: Codable {
    var avsResult: String?

    enum CodingKeys: String, CodingKey {
        case avsResult = "AVSResult"
    }

    public init(avsResult: String? = nil) {
        self.avsResult = avsResult
    }
}


