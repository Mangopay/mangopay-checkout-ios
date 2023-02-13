//
//  AssetIdentifier.swift
//  OZE
//
//  Created by Elikem Savie on 25/04/2022.
//

import UIKit

extension UIImage {

    enum AssetIdentifier: String {
        case dropDownIcon
        case card_amex
        case card_diners
        case card_visa
        case card_unionpay
        case card_mastercard
        case card_discover
        case card_jcb
        case none
    }

    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue, in: Bundle.module, with: nil)
    }

}
