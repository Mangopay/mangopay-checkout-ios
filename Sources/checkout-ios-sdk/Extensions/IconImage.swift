//
//  IconImage.swift
//  OZE
//
//  Created by Elikem Savie on 21/06/2022.
//

import UIKit

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
