//
//  AssetIdentifier.swift
//  OZE
//
//  Created by Elikem Savie on 25/04/2022.
//

#if os(iOS)
import UIKit
#endif

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
        case card_maestro
        case paypal
        case app_icon
        case cartebancaire
        case none
    }

    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue, in: Bundle.mgpInternal, with: nil)
    }

}
