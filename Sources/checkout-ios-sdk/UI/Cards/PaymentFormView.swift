//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation
import UIKit

enum FormType {
    case dropIn
    case element
}
//4000002760003184
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
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textfield in
        textfield.setRightImage(nil, text: "Choose Card")
        textfield.onRightButtonTappedAction = {
            self.onRightButtonTappedAction?()
        }
    }

    lazy var cardNameField = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_NAME_PLACEHOLDER,
        returnKeyType: .next,
        validationRule: [
            .fullNameRequired,
            .textTooShort
        ],
        style: self.paymentFormStyle,
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
        style: self.paymentFormStyle,
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
        style: self.paymentFormStyle,
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
        style: self.paymentFormStyle,
        textfieldDelegate: self
    )

    lazy var zipCodeField = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_ZIP_PLACEHOLDER,
        returnKeyType: .done,
        validationRule: [
            .textTooShort
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textF in
        textF.textfield.autocorrectionType = .no
    }

    lazy var statusLabel = UILabel.create(
        text: "",
        font: .systemFont(ofSize: 12, weight: .medium)
    )

    lazy var firstNameTextfield = WhenThenDropDownTextfield(
        placeholderText: LocalizableString.CARD_COUNTRY_PLACEHOLDER,
        showDropDownIcon: true,
        style: self.paymentFormStyle,
        textfieldDelegate: self
    )

    lazy var lastNameTextfield = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_ZIP_PLACEHOLDER,
        returnKeyType: .done,
        validationRule: [
            .textTooShort
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textF in
        textF.textfield.autocorrectionType = .no
    }

    lazy var addressLine1Field = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_ZIP_PLACEHOLDER,
        returnKeyType: .done,
        validationRule: [
            .textTooShort
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textF in
        textF.textfield.autocorrectionType = .no
    }

    lazy var addressLine2Field = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_ZIP_PLACEHOLDER,
        returnKeyType: .done,
        validationRule: [
            .textTooShort
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textF in
        textF.textfield.autocorrectionType = .no
    }

    lazy var cityAddressField = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_ZIP_PLACEHOLDER,
        returnKeyType: .done,
        validationRule: [
            .textTooShort
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textF in
        textF.textfield.autocorrectionType = .no
    }

    lazy var stateField = WhenThenTextfield(
        placeholderText: LocalizableString.CARD_ZIP_PLACEHOLDER,
        returnKeyType: .done,
        validationRule: [
            .textTooShort
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textF in
        textF.textfield.autocorrectionType = .no
    }

    lazy var paymentButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = paymentFormStyle.checkoutButtonBackgroundColor
        button.setTitle("Checkout", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onTappedButton), for: .touchUpInside)
        button.setTitleColor(paymentFormStyle.checkoutButtonTextColor, for: .normal)
        return button
    }()

    lazy var activitySpiner = UIActivityIndicatorView()
    
    var expiryMonth: Int?
    var expiryYear: Int?

    var tapGesture: UIGestureRecognizer?
    var formType: FormType = .dropIn

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
            paymentButton,
            statusLabel
        ]
    ) { stackView in
        stackView.setCustomSpacing(16, after: self.headerView)
        stackView.setCustomSpacing(24, after: self.checkMarkStack)
        stackView.setCustomSpacing(8, after: self.billingInfoTitle)
        stackView.setCustomSpacing(16, after: self.zipCodeField)
        stackView.setCustomSpacing(32, after: self.paymentButton)
    }

    var keyboardUtil: KeyboardUtil?
    var topConstriant: NSLayoutConstraint!
    var viewModel: PaymentFormViewModel!
    var onRightButtonTappedAction: (() -> Void)?
    
    var paymentFormStyle: PaymentFormStyle
    
    lazy var forms: [Validatable] = [
        cardNumberField,
        cardNameField,
        expiryDateField,
        cvvField
    ]

    init(paymentFormStyle: PaymentFormStyle?, formType: FormType) {
        self.formType = formType
        self.paymentFormStyle = paymentFormStyle ?? PaymentFormStyle()
        self.viewModel = PaymentFormViewModel(clientId: WhenThenSDK.clientID)
        super.init(frame: .zero)
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
        activitySpiner.isHidden = true
        
        cardNumberField.text = "4000002760003184"
//        cardNameField.text = "Elikem"
//        cvvField.text = "120"
//        expiryDateField.text = "12/26"
        
        cardNumberField.onEditingChanged = { text in
            let cardType = LuhnChecker.getCreditCardType(cardNumber: text)
            print("🤣 cardType", cardType)
            self.cardNumberField.setRightImage(cardType.icon)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(vStack)
        addSubview(activitySpiner)
        
        topConstriant = vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
        topConstriant.isActive = true

        vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        vStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        activitySpiner.translatesAutoresizingMaskIntoConstraints = false
        activitySpiner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activitySpiner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activitySpiner.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activitySpiner.widthAnchor.constraint(equalToConstant: 30).isActive = true
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
        
        var customer = Customer()
        let billingInfo = BillingInfo(
            line1: "j153",
            line2: "Prickasd",
            city: "accra",
            postalCode: "GH 21331",
            state: "Accra",
            country: "Ghana"
        )
        customer.billingAddress = billingInfo
        customer.description = "Happy Customer"
        customer.email = "elviva96@gmail.com"
        customer.name = "Elikem Savie"
        customer.phone = "0545543521"
        let shippingAddress = ShippingAddress(
            address: billingInfo,
            name: "Elikem",
            phone: "Accra"
        )
        customer.shippingAddress = shippingAddress
        customer.company = Company(name: "File", number: "+233542442442")
        
        let cusInput = CustomerInputData(card: formData, customer: customer)
    

        Task {
            activitySpiner.isHidden = false
            activitySpiner.startAnimating()
            switch formType {
            case .dropIn:
                await viewModel.performDropin(with: formData.toPaymentCardInput(), cardToken: nil)
            case .element:
                await viewModel.tokeniseCard()
            }
            activitySpiner.stopAnimating()
        }
        
    }

    func setCards(cards: CardConfig?) {
        headerView.set(cards)
    }

    func setUsersCards(_ cards: [CardType]) {
        cardNumberField.setRightImage(UIImage(systemName: "plus"), text: "Choose Card")
//        cardNumberField.setData(cards: cards)
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
