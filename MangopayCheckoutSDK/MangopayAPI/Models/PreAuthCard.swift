//
//  File 2.swift
//  
//
//  Created by Elikem Savie on 01/06/2023.
//

import Foundation

public protocol Payable {
    var authorID: String? { set get }
    var debitedFunds: Amount? { set get }
    var secureMode: String? { set get }
    var cardID: String? { set get }
    var secureModeNeeded: Bool? { set get }
    var secureModeRedirectURL: String? { set get }
    var secureModeReturnURL: String? { set get }
}

// MARK: - PayInCard
public struct PreAuthCard: Codable, Payable {

    public enum PaymentStatusEnum: String {
        case VALIDATED
        case WAITING
        case FAILED
    }

    public enum StatusEnum: String {
        case CREATED
        case SUCCEEDED
        case FAILED
    }

    public var authorID: String?
    public var debitedFunds, remainingFunds: Amount?
    var status, paymentStatus, resultCode, resultMessage: String?
    public var executionType, secureMode, cardID: String?
    public var secureModeNeeded: Bool?
    public var secureModeRedirectURL, secureModeReturnURL: String?
    var expirationDate: Int?
    var payInID: String?
    var billing: Ing?
    var securityInfo: SecurityInfo?
    var culture: String?
    var multiCapture: Bool?
    var ipAddress: String?
    var browserInfo: BrowserInfo?
    var shipping: Ing?
    var profilingAttemptReference: String?

    public var _paymentStatus: PaymentStatusEnum? {
        guard let _str = paymentStatus else { return nil }
        return PaymentStatusEnum(rawValue: _str)
    }

    public var _status: StatusEnum? {
        guard let _str = status else { return nil }
        return StatusEnum(rawValue: _str)
    }

    enum CodingKeys: String, CodingKey {
        case authorID = "AuthorId"
        case debitedFunds = "DebitedFunds"
        case remainingFunds = "RemainingFunds"
        case status = "Status"
        case paymentStatus = "PaymentStatus"
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case executionType = "ExecutionType"
        case secureMode = "SecureMode"
        case cardID = "CardId"
        case secureModeNeeded = "SecureModeNeeded"
        case secureModeRedirectURL = "SecureModeRedirectURL"
        case secureModeReturnURL = "SecureModeReturnURL"
        case expirationDate = "ExpirationDate"
        case payInID = "PayInId"
        case billing = "Billing"
        case securityInfo = "SecurityInfo"
        case culture = "Culture"
        case multiCapture = "MultiCapture"
        case ipAddress = "IpAddress"
        case browserInfo = "BrowserInfo"
        case shipping = "Shipping"
        case profilingAttemptReference = "ProfilingAttemptReference"
    }

    public init(authorID: String, debitedFunds: Amount, remainingFunds: Amount? = nil, status: String? = nil, paymentStatus: String? = nil, resultCode: String? = nil, resultMessage: String? = nil, executionType: String? = nil, secureMode: String? = nil, cardID: String, secureModeNeeded: Bool, secureModeRedirectURL: String? = nil, secureModeReturnURL: String? = nil, expirationDate: Int? = nil, payInID: String? = nil, billing: Ing? = nil, securityInfo: SecurityInfo? = nil, culture: String? = nil, multiCapture: Bool? = nil, ipAddress: String = "2001:0620:0000:0000:0211:24FF:FE80:C12C", browserInfo: BrowserInfo = BrowserInfo(), shipping: Ing? = nil, profilingAttemptReference: String?) {
        self.authorID = authorID
        self.debitedFunds = debitedFunds
        self.remainingFunds = remainingFunds
        self.status = status
        self.paymentStatus = paymentStatus
        self.resultCode = resultCode
        self.resultMessage = resultMessage
        self.executionType = executionType
        self.secureMode = secureMode
        self.cardID = cardID
        self.secureModeNeeded = secureModeNeeded
        self.secureModeRedirectURL = secureModeRedirectURL
        self.secureModeReturnURL = secureModeReturnURL
        self.expirationDate = expirationDate
        self.payInID = payInID
        self.billing = billing
        self.securityInfo = securityInfo
        self.culture = culture
        self.multiCapture = multiCapture
        self.ipAddress = ipAddress
        self.browserInfo = browserInfo
        self.shipping = shipping
        self.profilingAttemptReference = profilingAttemptReference
    }
}

