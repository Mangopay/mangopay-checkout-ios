//
//  IconImage.swift
//  OZE
//
//  Created by Elikem Savie on 21/06/2022.
//

#if os(iOS)
import UIKit
#endif

class IconImage: UIImageView {

    static func create(
        iconName: UIImage.AssetIdentifier,
        iconHeight: CGFloat = 30,
        iconWidth: CGFloat = 30,
        contentMode: UIView.ContentMode = .scaleAspectFill
    ) -> UIImageView {
        let imageView = IconImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: iconWidth).isActive = true
        imageView.image = UIImage(assetIdentifier: iconName)
        imageView.contentMode = contentMode
        return imageView
    }

}

class IconButton: UIButton {

    static func create(
        title: String,
        iconName: UIImage.AssetIdentifier = .none,
        iconSystemName: String? = nil,
        iconSystemColor: UIColor? = .black,
        iconHeight: CGFloat = 30,
        iconWidth: CGFloat = 30,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        alignment: UIControl.ContentHorizontalAlignment? = nil,
        buttonAction: ((IconButton) -> Void)? = nil
    ) -> UIButton {
        let button = IconButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: iconWidth).isActive = true
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 8)

        if let sysName = iconSystemName, iconName == .none {
            let image = UIImage(systemName: sysName)
            button.setImage(image, for: .normal)
            button.tintColor = iconSystemColor
        } else {
            button.setImage(UIImage(assetIdentifier: iconName), for: .normal)
        }

        button.contentMode = contentMode
        buttonAction?(button)
        if let alignment = alignment {
            button.contentHorizontalAlignment = alignment
        }
        return button
    }
}
