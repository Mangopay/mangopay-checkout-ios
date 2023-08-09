//
//  File.swift
//  
//
//  Created by Elikem Savie on 03/05/2023.
//

import Foundation
import UIKit

public struct CardTypeChecker {
    
    public static func getCreditCardType(cardNumber: String) -> CardType {
        
        let VISA_Regex = "^4\\d*$"
        let MasterCard_Regex = "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)\\d*$"
        let AmericanExpress_Regex = "^3[47]\\d*$"
        let DinersClub_Regex = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        let Discover_Regex = "^(6011|65|64[4-9])\\d*$"
        let JCB_Regex = "^(2131|1800|35)\\d*$"
        let diner = "^3(0[0-5]|[689])\\d*$"
        let unionPay = "^(((620|(621(?!83|88|98|99))|622(?!06|018)|62[3-6]|627[02,06,07]|628(?!0|1)|629[1,2]))\\d*|622018\\d{12})$"
        let maestro = "^(?:5[06789]\\d\\d|(?!6011[0234])(?!60117[4789])(?!60118[6789])(?!60119)(?!64[456789])(?!65)6\\d{3})\\d{8,15}$"
    
        print("🤣 cardNumber", cardNumber)
        if cardNumber.isMatch(VISA_Regex) {
            return .visa
        } else if cardNumber.isMatch(MasterCard_Regex) {
            return .mastercard
        } else if cardNumber.isMatch(AmericanExpress_Regex) {
            return .amex
        } else if cardNumber.isMatch(DinersClub_Regex) {
            return .diner
        } else if cardNumber.isMatch(Discover_Regex) {
            return .discover
        } else if cardNumber.isMatch(JCB_Regex) {
            return .jcb
        } else {
            return .none
        }
        
    }

}

public enum CardType: String, Codable, CaseIterable {
    case amex = "AMEX"
    case diner = "DINER"
    case visa = "VISA"
    case unionPay = "UNIONPAY"
    case mastercard = "MASTERCARD"
    case discover = "DISCOVER"
    case jcb
    case none

    public var icon: UIImage? {
        switch self {
        case .amex:
            return UIImage.init(assetIdentifier: .card_amex)
        case .diner:
            return UIImage.init(assetIdentifier: .card_diners)
        case .visa:
            return UIImage.init(assetIdentifier: .card_visa)
        case .unionPay:
            return UIImage.init(assetIdentifier: .card_unionpay)
        case .mastercard:
            return UIImage.init(assetIdentifier: .card_mastercard)
        case .discover:
            return UIImage.init(assetIdentifier: .card_discover)
        case .jcb:
            return UIImage.init(assetIdentifier: .card_jcb)
        case .none:
            return UIImage(systemName: "creditcard")
        }
    }

    public var cardCount: Int {
        switch self {
        case .amex:
            return 15
        case .diner:
            return 14
        case .visa:
            return 16
        case .unionPay:
            return 16
        case .mastercard:
            return 16
        case .discover:
            return 16
        case .jcb:
            return 16
        case .none:
            return 16
        }
    }
}
