//
//  UILabel+Extension.swift
//  OZE
//
//  Created by Mojisola Adebiyi on 26/04/2022.
//

import Foundation
#if os(iOS)
import UIKit
#endif

extension UILabel {

    static func create(
        text: String? = nil,
        color: UIColor? = nil,
        font: UIFont? = nil,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 0,
        adjustsFontSizeToFitWidth: Bool = false,
        clabel: ((UILabel) -> Void)? = nil
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        
        if let font = font {
            label.font = font
        }

        if let color = color {
            label.textColor = color
        }

        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        clabel?(label)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return label
    }
}
