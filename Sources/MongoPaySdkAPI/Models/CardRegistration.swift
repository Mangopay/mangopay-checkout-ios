//
//  File.swift
//  
//
//  Created by Elikem Savie on 26/02/2023.
//

import Foundation

struct CardRegistration: Codable {
    var userID, currency, accessKey, preregistrationData: String?
    var cardRegistrationURL, registrationData, cardType, cardID: String?
    var resultCode, resultMessage, status: String?

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case currency = "Currency"
        case accessKey = "AccessKey"
        case preregistrationData = "PreregistrationData"
        case cardRegistrationURL = "CardRegistrationURL"
        case registrationData = "RegistrationData"
        case cardType = "CardType"
        case cardID = "CardId"
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case status = "Status"
    }
}
