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

enum TextFieldState {
    case error
    case active
    case highlighted
    case inactive
    case greyedOut
}

public class MangoPayTextfield: UIView {

    var onEditingBegin: (() -> Void)?
    var onEditingDidEnd: (() -> Void)?
    var onEditingChanged: ((String) -> Void)?
    var onRightButtonTappedAction: (() -> Void)?
    let placeholderText: String?
    
    public var validationRules: [ValidationRules]

    public var errorText: String? {
        didSet {
            errorLabel.text = errorText
        }
    }

    public var text: String? {
        get { return textfield.text?.trimmingCharacters(in: .whitespaces) }
        set { textfield.text = newValue }
    }

    var trimmedText: String? { return textfield.text?.trimmingCharacters(in: .whitespaces) }

    public lazy var textfield: UITextField = {
        let view = UITextField()
        view.font = style.font
        view.textColor = style.textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var leftImageView = IconImage.create(iconName: .none, iconHeight: 20, iconWidth: 30)
    
    private lazy var rightImageButton = IconButton.create(
        title: "Choose Card",
        iconName: .none,
        iconSystemColor: .black,
        iconHeight: 30,
        iconWidth: 50,
        buttonAction: { button in
            button.isHidden = true
            button.titleLabel?.font = .systemFont(ofSize: 7, weight: .regular)
            button.setTitleColor(.black, for: .normal)
            button.tintColor = .black
            button.addTarget(
                self,
                action: #selector(self.onRightButtonTapped),
                for: .touchUpInside
            )
        }
    )

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
        views: [leftImageView, textfield, rightImageButton]
    )

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = style.borderColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = style.borderType == .round ? 8 : 0
        view.addSubview(hStack)
        hStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        hStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        hStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        hStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
        return view
    }()

    private lazy var errorLabel = UILabel.create(
        text: "",
        color: style.errorColor,
        font: .systemFont(ofSize: 11)
    ) { textfield in
        textfield.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }

    private lazy var vStack = UIStackView.create(
        spacing: 4,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        views: [containerView, errorLabel]
    )
    
    var style: PaymentFormStyle

    public init(
        placeholderText: String? = nil,
        leftImage: UIImage? = nil,
        rightImage: UIImage? = nil,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .done,
        validationRule: [ValidationRules],
        allowsInteraction: Bool = true,
        style: PaymentFormStyle,
        textfieldDelegate: UITextFieldDelegate? = nil,
        textfield: ((MangoPayTextfield) -> Void)? = nil
    ) {
        self.validationRules = validationRule
        self.placeholderText = placeholderText
        self.style = style
        super.init(frame: .zero)
        setupView()
        textfield?(self)

        addTextfieldTargets()
        self.setPlaceHolder(with: placeholderText)
        self.setLeftImage(leftImage)
        self.setRightImage(rightImage)
        self.textfield.delegate = textfieldDelegate
        self.textfield.keyboardType = keyboardType
        self.textfield.returnKeyType = returnKeyType
        self.isUserInteractionEnabled = allowsInteraction
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }

    private func addTextfieldTargets() {
        textfield.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    func setPlaceHolder(with text: String?) {
        let placeholderText = NSAttributedString(
            string: text ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: style.placeHolderColor]
        )
        textfield.attributedPlaceholder = placeholderText
    }

    func setLeftImage(_ image: UIImage?, withAnimation: Bool = false) {
        leftImageView.image = image
        leftImageView.isHidden = image == nil
    }

    func setRightImage(_ image: UIImage?, text: String? = nil) {
//        rightImageButton.setImage(UIImage(), for: .normal)
        rightImageButton.isHidden = (image == nil) && (text == nil)
//        rightImageButton.setTitle(text, for: .normal)
    }

    public func setResponsder() {
        textfield.becomeFirstResponder()
    }
            
    @objc private func onRightButtonTapped() {
        onRightButtonTappedAction?()
        updateViewWith(state: .inactive)
    }

    @objc private func editingDidEnd() {
        onEditingDidEnd?()
        updateViewWith(state: .inactive)
    }

    @objc private func editingDidBegin() {
        onEditingBegin?()
        updateViewWith(state: .active)
    }

    @objc private func editingChanged() {
        onEditingChanged?(trimmedText ?? "")
        updateViewWith(state: .active)
    }

    func updateViewWith(state: TextFieldState) {
        containerView.layer.borderWidth = 1
        switch state {
        case .error:
            containerView.layer.borderColor = style.errorColor.cgColor
        case .active:
            containerView.layer.borderColor = style.borderFocusedColor.cgColor
            errorText = ""
        case .highlighted:
            containerView.layer.borderColor = style.borderFocusedColor.cgColor
            containerView.layer.borderWidth = 4
            errorText = ""
        case .inactive:
            containerView.layer.borderColor = style.borderColor.cgColor
            errorText = ""
        case .greyedOut:
            containerView.layer.borderColor = style.borderColor.cgColor
            containerView.backgroundColor = UIColor.gray
            errorText = ""
        }
    }

    func showError(message: String) {
        errorText = message
        updateViewWith(state: .error)
    }
}

extension MangoPayTextfield: Validatable {
    public var inputData: String {
        return trimmedText ?? ""
    }

    public func triggerError(message: String) {
        showError(message: message)
    }

    public var identifier: String {
        return placeholderText ?? ""
    }
}
