//
//  File.swift
//  
//
//  Created by Elikem Savie on 16/10/2022.
//

import Foundation
#if os(iOS)
import UIKit
#endif

extension UIScrollView {

    static func createWithVStack(
        spacing: CGFloat,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        views: [UIView],
        stackview: ((UIStackView) -> Void)? = nil
    ) -> UIScrollView {

        let stackView = UIStackView()
        stackView.spacing = spacing
        stackView.axis = .vertical
        stackView.alignment = alignment
        stackView.distribution = distribution
        views.forEach({stackView.addArrangedSubview($0)})
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackview?(stackView)

        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding.top).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: padding.left).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -padding.right).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding.bottom).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }

}
