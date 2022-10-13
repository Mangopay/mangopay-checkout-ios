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
        leftImage: UIImage(assetIdentifier: .none),
        keyboardType: .numberPad,
        returnKeyType: .next
    )

    lazy var cardNameField = WhenThenTextfield(
        placeholderText: "Name on Card",
        returnKeyType: .next
    )

    lazy var expiryDateField = WhenThenDropDownTextfield(
        placeholderText: "MM/YY",
        showDropDownIcon: false
    )

    lazy var cvvField = WhenThenTextfield(
        placeholderText: "CVV",
        returnKeyType: .next
    )
    
    private lazy var hStack = UIStackView.create(
        spacing: 8,
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        views: [expiryDateField, cvvField]
    )

    lazy var saveDetailsCheckMark = CheckmarkView(title: "Save payment details for future use")
    
    lazy var billingAddressCheckMark = CheckmarkView(title: "Save payment details for future use")
    
    private lazy var checkMarkStack = UIStackView.create(
        spacing: 2,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        views: [saveDetailsCheckMark, billingAddressCheckMark]
    )

    lazy var billingInfoTitle = UILabel.create(text: "Billing Information")
    
    lazy var countryField = WhenThenDropDownTextfield(
        placeholderText: "Select Country",
        showDropDownIcon: true
    )

    lazy var zipCodeField = WhenThenTextfield(
        placeholderText: "ZIP/ Postal Code",
        returnKeyType: .next
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
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        loadCountries()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
//        translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
//        vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        self.backgroundColor = .white
    }

    func loadCountries() {
        Utils().loadCountries()
    }
}
