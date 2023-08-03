//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/10/2022.
//

import Foundation
#if os(iOS)
import UIKit
#endif

class CheckmarkView: UIView {
    
    var isSelected = false

    lazy var chekmarkImage = IconImage.create(
        iconName: ".dropDownIcon",
        iconHeight: 16,
        iconWidth: 16,
        contentMode: .center
    )

    lazy var titleLabel = UILabel.create(
        text: "",
        font: .systemFont(ofSize: 14, weight: .medium),
        numberOfLines: 1
    )
    
    lazy var vStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [chekmarkImage, titleLabel])
        view.spacing = 8
        view.axis = .horizontal
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var pseudoButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.addTarget(self, action: #selector(toggleSelector), for: .touchUpInside)
        return button
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        addSubview(pseudoButton)
        vStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        vStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        pseudoButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pseudoButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        self.heightAnchor.constraint(equalToConstant: 20).isActive = true
        chekmarkImage.layer.cornerRadius = 4
        chekmarkImage.layer.borderWidth = 1
        chekmarkImage.layer.borderColor = UIColor.gray.cgColor
        chekmarkImage.tintColor = .black
    }

    @objc func toggleSelector() {
        isSelected = !isSelected
        chekmarkImage.image = isSelected ? UIImage(systemName: "checkmark") : nil
    }

}
