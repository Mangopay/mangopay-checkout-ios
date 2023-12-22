//
//  UIStackView+Extensions.swift
//  WhenThen
//
//  Created by Elikem Savie on 12/10/2022.
//

#if os(iOS)
import UIKit
#endif

extension UIStackView {

    static func create(
        spacing: CGFloat = 0,
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution,
        views: [UIView],
        stackview: ((UIStackView) -> Void)? = nil
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.spacing = spacing
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackview?(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

}
