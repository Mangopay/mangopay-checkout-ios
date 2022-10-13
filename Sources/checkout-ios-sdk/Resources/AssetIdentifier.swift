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
        case none
    }

    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }

}
