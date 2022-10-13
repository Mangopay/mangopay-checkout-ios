//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import UIKit

class CardCell: UICollectionViewCell {
    static let id = "\(CardCell.self)"

    lazy var cardImage = IconImage.create(iconName: .dropDownIcon, iconHeight: 20, iconWidth: 40)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        cardImage.backgroundColor = .yellow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(cardImage)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        cardImage.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        cardImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        cardImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        cardImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        layer.cornerRadius = 4
    }

 
    func configure(with card: Card) {
        cardImage.image = UIImage(assetIdentifier: .dropDownIcon)
    }

}
