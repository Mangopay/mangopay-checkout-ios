//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/10/2022.
//

import Foundation
import UIKit

class CheckmarkView: UIView {
    
    lazy var chekmarkImage = IconImage.create(
        iconName: .dropDownIcon,
        iconHeight: 16,
        iconWidth: 16
    )

    lazy var titleLabel = UILabel.create(text: "", numberOfLines: 1)
    
    lazy var vStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [chekmarkImage, titleLabel])
        view.spacing = 8
        view.axis = .horizontal
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(title: String) {
        super.init(frame: .zero)
//        self.chekmarkImage.image = UIImage(assetIdentifier: checkImage)
        self.titleLabel.text = title
        setupView()
        chekmarkImage.backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        vStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        backgroundColor = .yellow
    }

}
