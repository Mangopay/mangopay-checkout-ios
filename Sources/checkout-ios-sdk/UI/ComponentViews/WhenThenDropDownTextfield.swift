//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/10/2022.
//

import Foundation
import UIKit

class WhenThenDropDownTextfield: UIView {
    
    var didTapContainer: (() -> Void)?
    var showDropDownIcon = true

    lazy var textfield: UITextField = {
        let view = UITextField()
//        view.font = .bodyText1(for: .regular)
//        view.textColor = .grayScale(.black)
        view.tintColor = .clear
//        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var containerView: UIView = {
        let imageView = UIImageView(image: UIImage(assetIdentifier: .dropDownIcon))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true

        view.addSubview(imageView)
        view.addSubview(textfield)
        textfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        textfield.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textfield.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -8).isActive = true

        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        imageView.isHidden = !showDropDownIcon

        return view
    }()

    init(
        placeholderText: String? = nil,
        showDropDownIcon: Bool = true
    ) {
        self.showDropDownIcon = showDropDownIcon
        super.init(frame: .zero)
        setupView()

        addtTapGestures()
        self.setPlaceHolder(with: placeholderText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    private func addtTapGestures() {
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTapSelf)
        ))
    }
    
    func setPlaceHolder(with text: String?) {
        let placeholderText = NSAttributedString(
            string: text ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textfield.attributedPlaceholder = placeholderText
    }

    @objc private func didTapSelf() {
        didTapContainer?()
    }
}
