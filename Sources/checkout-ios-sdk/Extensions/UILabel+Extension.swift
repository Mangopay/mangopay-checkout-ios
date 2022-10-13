//
//  UILabel+Extension.swift
//  OZE
//
//  Created by Mojisola Adebiyi on 26/04/2022.
//

import Foundation
import UIKit

extension UILabel {

    static func create(
        text: String? = nil,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 0,
        adjustsFontSizeToFitWidth: Bool = false,
        clabel: ((UILabel) -> Void)? = nil
    ) -> UILabel {
        let label = UILabel()
        label.text = text

        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        clabel?(label)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return label
    }
}
