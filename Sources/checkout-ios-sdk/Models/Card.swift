//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation
import UIKit

enum CardType: Codable, CaseIterable {
    case amex
    case diner
    case visa
    case unionPay
    case mastercard
    case discover

    var icon: UIImage? {
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
        }
    }
}

struct Card: Codable {
    let name: String?
    let type: String?
    let imageURL: URL?
    var cardtype: CardType = .amex
}
