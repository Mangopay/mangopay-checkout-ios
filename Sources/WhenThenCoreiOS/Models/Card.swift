//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation
import UIKit
import WhenThenSdkAPI

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
}

struct Card: Codable {
    let name: String?
    let type: String?
    let imageURL: URL?
    var cardtype: CardType = .amex
}

extension ListCustomerCard {
    var brandType: CardType? {
        guard let brandStr = brand else { return nil }
        return CardType(rawValue: brandStr)
    }
}
