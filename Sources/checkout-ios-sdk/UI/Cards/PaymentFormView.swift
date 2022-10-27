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
        validationRule: [
            .cardMinimmun,
            .cardNumberRequired,
            .invalidCardNumber
        ],
        textfieldDelegate: self
    )

    lazy var cardNameField = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_NAME_PLACEHOLDER,
        returnKeyType: .next,
        validationRule: [
            .fullNameRequired,
            .textTooShort
        ],
        textfieldDelegate: self
    )

    lazy var expiryDateField = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_EXPIRIY_PLACEHOLDER,
        keyboardType: .numberPad,
        returnKeyType: .next,
        validationRule: [
            .cardExpired,
            .dateRequired
        ],
        textfieldDelegate: self
    )

    lazy var cvvField = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_CVV,
        keyboardType: .numberPad,
        returnKeyType: .next,
        validationRule: [
            .cvvRequired,
            .textTooShort
        ],
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
        title: LocalizableString.SAVE_PAYMENT_CHECKMARK
    )
    
    lazy var billingAddressCheckMark = CheckmarkView(
        title: LocalizableString.BILLING_ADDRESS_CHECKMARK
    )
    
    private lazy var checkMarkStack = UIStackView.create(
        spacing: 6,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        views: [saveDetailsCheckMark, billingAddressCheckMark]
    )

    lazy var billingInfoTitle = UILabel.create(
        text: LocalizableString.BILLING_INFO_TITLE,
        font: .systemFont(ofSize: 16, weight: .medium)
    )
    
    lazy var countryField = WhenThenDropDownTextfield(
        placeholderText: LocalizableString.CARD_COUNTRY_PLACEHOLDER,
        showDropDownIcon: true,
        textfieldDelegate: self
    )

    lazy var zipCodeField = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_ZIP_PLACEHOLDER,
        returnKeyType: .done,
        validationRule: [
            .textTooShort
        ],
        textfieldDelegate: self
    ) { textF in
        textF.textfield.autocorrectionType = .no
    }

    lazy var paymentButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Checkout", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onTappedButton), for: .touchUpInside)
        return button
    }()

    lazy var activitySpineer = UIActivityIndicatorView()
    
    var expiryMonth: Int?
    var expiryYear: Int?

    var tapGesture: UIGestureRecognizer?

    private lazy var vStack = UIScrollView.createWithVStack(
        spacing: 16,
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
            zipCodeField,
            paymentButton
        ]
    ) { stackView in
        stackView.setCustomSpacing(16, after: self.headerView)
        stackView.setCustomSpacing(24, after: self.checkMarkStack)
        stackView.setCustomSpacing(8, after: self.billingInfoTitle)
        stackView.setCustomSpacing(16, after: self.zipCodeField)
    }

    var keyboardUtil: KeyboardUtil?
    var topConstriant: NSLayoutConstraint!
    let viewModel = PaymentFormViewModel()
    
    lazy var forms: [Validatable] = [
        cardNumberField,
        cardNameField,
        expiryDateField,
        cvvField
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        tapGesture = UIGestureRecognizer(
            target: self,
            action: #selector(onViewTap)
        )
        
        setupView()
        loadCountries()
        
        keyboardUtil = KeyboardUtil(
            original: self.topConstriant.constant,
            padding: 0
        )
        keyboardUtil?.delegate = self
        keyboardUtil?.register()
        activitySpineer.isHidden = true
        
        cardNumberField.text = "1234 1234 1234 1234"
        cardNameField.text = "Elikem"
        cvvField.text = "120"

        cardNameField.onEditingChanged = { text in
//            let cardType = LuhnChecker.getCreditCardType(cardNumber: text)
//            print("🤣 cardType", cardType)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(vStack)
        addSubview(activitySpineer)
        
        topConstriant = vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
        topConstriant.isActive = true

        vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        vStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        activitySpineer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activitySpineer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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

    @objc func onViewTap() {
        self.endEditing(true)
        print("🤣🤣🤣🤣")
    }

    @objc func onTappedButton() {
        grabData()
    }

    func grabData() {
        let formData = FormData(
            number: cardNumberField.text,
            name: cardNameField.text,
            expMonth: expiryMonth,
            expYear: expiryYear,
            cvc: cvvField.text,
            savePayment: saveDetailsCheckMark.isSelected,
            bilingInfo: BillingInfo(
                line1: nil,
                line2: zipCodeField.text ?? "",
                city: nil,
                postalCode: nil,
                state: nil,
                country: countryField.text
            )
        )

        viewModel.formData = formData
        Task {
            await viewModel.tokeniseCard()
        }
        activitySpineer.isHidden = false
        activitySpineer.startAnimating()
    }

    func setCards(cards: CardConfig?) {
        headerView.set(cards)
    }
}


extension PaymentFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cardNumberField.textfield:
            cardNameField.setResponsder()
        case cardNameField.textfield:
            expiryDateField.setResponsder()
        case expiryDateField.textfield:
            cvvField.setResponsder()
        case cvvField.textfield:
            countryField.setResponsder()
        case zipCodeField.textfield:
            self.endEditing(true)
        default: break
        }
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        switch textField {
        case cardNumberField.textfield:
            if [6, 11, 16].contains(textField.text?.count ?? 0) && string.isEmpty {
                textField.text = String(textField.text!.dropLast())
                return true
            }
            
            let text = NSString(string: textField.text ?? "").replacingCharacters(
                in: range,
                with: string
            ).replacingOccurrences(of: " ", with: "")
            
            if text.count >= 4 && text.count <= 16 {
                var newString = ""
                for i in stride(from: 0, to: text.count, by: 4) {
                    let upperBoundIndex = i + 4
                    
                    let lowerBound = String.Index.init(encodedOffset: i)
                    let upperBound = String.Index.init(encodedOffset: upperBoundIndex)
                    
                    if upperBoundIndex <= text.count  {
                        newString += String(text[lowerBound..<upperBound]) + " "
                        if newString.count > 19 {
                            newString = String(newString.dropLast())
                        }
                    }
                    
                    else if i <= text.count {
                        newString += String(text[lowerBound...])
                    }
                }
                
                textField.text = newString
                return false
            }
            
            if text.count > 16 {
                return false
            }
            
            let cardType = LuhnChecker.getCreditCardType(
                cardNumber: text.trimmingCharacters(in: .whitespaces)
            )
            cardNumberField.setLeftImage(cardType.icon)
            return true
            
        case expiryDateField.textfield:
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            let updatedText = oldText.replacingCharacters(in: r, with: string)
            
            if string == "" {
                if updatedText.count == 2 {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
            } else if updatedText.count == 1 {
                if updatedText > "1" {
                    return false
                }
            } else if updatedText.count == 2 {
                if updatedText <= "12" { //Prevent user to not enter month more than 12
                    textField.text = "\(updatedText)/" //This will add "/" when user enters 2nd digit of month
                }
                return false
            } else if updatedText.count == 5 {
                self.expDateValidation(dateStr: updatedText)
            } else if updatedText.count > 5 {
                return false
            }
            
            return true
        case cvvField.textfield:
            guard let preText = textField.text as NSString?,
                preText.replacingCharacters(in: range, with: string).count <= 4 else {
                return false
            }

            return true
    
        default: return true
        }
    }
    
    
    func expDateValidation(dateStr: String) {

        let currentYear = Calendar.current.component(.year, from: Date()) // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

//        let enteredYear = Int(dateStr.suffix(2)) ?? 0 // get last two digit from entered string as year
//        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        
        guard let actualDate = Date(dateStr, format: "MM/yy") else { return }
        let enteredYear = Calendar.current.dateComponents([.year], from: actualDate).year ?? 0
        let enteredMonth = Calendar.current.dateComponents([.month], from: actualDate).month ?? 0

        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                print("Entered Date Is Right")
                self.expiryMonth = enteredMonth
                self.expiryYear = enteredYear
            } else {
                print("Entered Date Is Wrong")
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                   print("Entered Date Is Right")
                    self.expiryMonth = enteredMonth
                } else {
                   print("Entered Date Is Wrong")
                }
            } else {
                print("Entered Date Is Wrong")
            }
        } else {
           print("Entered Date Is Wrong")
        }

    }

}

extension PaymentFormView: KeyboardUtilDelegate {

    func keyboardDidShow(sender: KeyboardUtil, rect: CGRect, animationDuration: Double) {
        let padding: CGFloat = 180
        let moveBy = rect.height - safeAreaInsets.bottom - padding
        print("🤣 moveBy", moveBy)
        topConstriant.constant = -moveBy

        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }

    }

    func keyboardDidHide(sender: KeyboardUtil, animationDuration: Double) {
        topConstriant.constant = sender.original
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard areFormsValidShowingError() else { return }
        
        switch textField {
        case cardNumberField.textfield:
            isFormValid(cardNumberField)
        case cardNameField.textfield:
            isFormValid(cardNameField)
        case expiryDateField.textfield:
            isFormValid(expiryDateField)
        case cvvField.textfield:
            isFormValid(cvvField)
        case zipCodeField.textfield:
            isFormValid(cvvField)
        default: break
        }
    }
    

}

extension PaymentFormView: FormValidatable {
    
}
