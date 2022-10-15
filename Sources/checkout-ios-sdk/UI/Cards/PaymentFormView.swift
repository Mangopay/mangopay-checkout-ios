//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation
import UIKit

class PaymentFormView: UIView {
    
    lazy var headerView = HeaderView()

    lazy var cardNumberField = WhenThenTextfield(
        placeholderText: "1234 1234 1234 1234",
        leftImage: UIImage(assetIdentifier: .card_visa),
        keyboardType: .numberPad,
        returnKeyType: .next,
        textfieldDelegate: self
    )

    lazy var cardNameField = WhenThenTextfield(
        placeholderText: "Name on Card",
        returnKeyType: .next,
        textfieldDelegate: self
    )

    lazy var expiryDateField = WhenThenDropDownTextfield(
        placeholderText: "MM/YY",
        showDropDownIcon: false,
        usecase: .date,
        textfieldDelegate: self
    )

    lazy var cvvField = WhenThenTextfield(
        placeholderText: "CVV",
        keyboardType: .numberPad,
        returnKeyType: .next,
        textfieldDelegate: self
    )
    
    private lazy var hStack = UIStackView.create(
        spacing: 8,
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        views: [expiryDateField, cvvField]
    )

    lazy var saveDetailsCheckMark = CheckmarkView(
        title: "Save payment details for future use"
    )
    
    lazy var billingAddressCheckMark = CheckmarkView(
        title: "Billing address is same as shipping"
    )
    
    private lazy var checkMarkStack = UIStackView.create(
        spacing: 6,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        views: [saveDetailsCheckMark, billingAddressCheckMark]
    )

    lazy var billingInfoTitle = UILabel.create(
        text: "Billing Information",
        font: .systemFont(ofSize: 16, weight: .medium)
    )
    
    lazy var countryField = WhenThenDropDownTextfield(
        placeholderText: "Select Country",
        showDropDownIcon: true,
        textfieldDelegate: self
    )

    lazy var zipCodeField = WhenThenTextfield(
        placeholderText: "ZIP/ Postal Code",
        returnKeyType: .done,
        textfieldDelegate: self
    )

    private lazy var vStack = UIStackView.create(
        spacing: 4,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        views: [
            headerView,
            cardNumberField,
            cardNameField,
            hStack,
            checkMarkStack,
            billingInfoTitle,
            countryField,
            zipCodeField
        ]
    ) { stackView in
        stackView.setCustomSpacing(16, after: self.headerView)
        stackView.setCustomSpacing(24, after: self.checkMarkStack)
        stackView.setCustomSpacing(8, after: self.billingInfoTitle)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        loadCountries()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        self.backgroundColor = .white
    }

    func loadCountries() {
        Utils().loadCountries(
            onSuccess: { countries in
                self.countryField.update(with: countries.map({$0.nameAndFlag ?? ""}))
            },
            onFailure: {
                
            }
        )
    }
}


extension PaymentFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cardNumberField.textfield:
            cardNameField.setResponsder()
        case cardNameField.textfield:
            expiryDateField.setResponsder()
        case cvvField.textfield:
            countryField.setResponsder()
        case zipCodeField.textfield:
            self.endEditing(true)
        default: break
        }
        return true
    }
}
