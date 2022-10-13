//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/10/2022.
//

import Foundation
import UIKit

class WhenThenTextfield: UIView {

    var onEditingBegin: (() -> Void)?
    var onEditingDidEnd: (() -> Void)?
    var onEditingChanged: ((String) -> Void)?

    var text: String? {
        get { return textfield.text?.trimmingCharacters(in: .whitespaces) }
        set { textfield.text = newValue }
    }

    var trimmedText: String? { return textfield.text?.trimmingCharacters(in: .whitespaces) }

    private lazy var textfield: UITextField = {
        let view = UITextField()
//        view.font = .bodyText1(for: .regular)
        view.textColor = .black
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()

    private lazy var leftImageView = IconImage.create(iconName: .none, iconHeight: 20, iconWidth: 30)

    private let verticalDividerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 6).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    private lazy var hStack = UIStackView.create(
        spacing: 8,
        axis: .horizontal,
        alignment: .center,
        distribution: .fillProportionally,
        views: [leftImageView, textfield]
    )

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.addSubview(hStack)
        hStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        hStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        hStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        hStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        return view
    }()

    
    init(
        placeholderText: String? = nil,
        leftImage: UIImage? = nil,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .done,
//        validationRule: [ValidationRules],
        allowsInteraction: Bool = true,
        textfield: ((WhenThenTextfield) -> Void)? = nil
    ) {
//        self.validationRules = validationRule
        super.init(frame: .zero)
        setupView()
        textfield?(self)

        addTextfieldTargets()
        self.setPlaceHolder(with: placeholderText)
        self.setLeftImage(leftImage)
        self.textfield.keyboardType = keyboardType
        self.textfield.returnKeyType = returnKeyType
        self.isUserInteractionEnabled = allowsInteraction
        leftImageView.backgroundColor = .yellow
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

    private func addTextfieldTargets() {
        textfield.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    func setPlaceHolder(with text: String?) {
        let placeholderText = NSAttributedString(
            string: text ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textfield.attributedPlaceholder = placeholderText
    }

    func setLeftImage(_ image: UIImage?) {
        leftImageView.image = image
        leftImageView.isHidden = image == nil
    }

    @objc private func editingDidEnd() {
        onEditingDidEnd?()
//        updateViewWith(state: .inactive)
    }

    @objc private func editingDidBegin() {
        onEditingBegin?()
//        updateViewWith(state: .active)
    }

    @objc private func editingChanged() {
        onEditingChanged?(trimmedText ?? "")
//        updateViewWith(state: .active)
    }
}
