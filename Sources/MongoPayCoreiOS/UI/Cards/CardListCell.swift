//
//  CardPickerView.swift
//  
//
//  Created by Elikem Savie on 28/10/2022.
//

import UIKit
import MongoPaySdkAPI

class CardListCell: UITableViewCell {

    lazy var cardImage = IconImage.create(iconName: .none, iconHeight: 20, iconWidth: 48)
    lazy var cardLabel = UILabel.create(color: .black, numberOfLines: 1)
    
    static let id = "CardListCell"

    private lazy var hStack = UIStackView.create(
        spacing: 8,
        axis: .horizontal,
        alignment: .center,
        distribution: .fillProportionally,
        views: [cardImage, cardLabel]
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(hStack)
        hStack.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        hStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        hStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true

    }

    func render(card: ListCustomerCard) {
        cardImage.image = card.brandType?.icon
        cardLabel.text = card.number
    }
}
