//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation
import PassKit
import MangoPaySdkAPI
//import NethoneSDK
#if os(iOS)
import UIKit
#endif

enum FormType {
    case dropIn
    case element
}

class PaymentFormView: UIView {
    
    lazy var headerView = HeaderView()

    lazy var cardNumberField = MangoPayTextfield(
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
        textfield.accessibilityLabel = "cardNumberField"
        textfield.onRightButtonTappedAction = {
            self.onRightButtonTappedAction?()
        }
    }

    lazy var cardNameField = MangoPayTextfield(
        placeholderText: LocalizableString.CARD_NAME_PLACEHOLDER,
        returnKeyType: .next,
        validationRule: [
            .fullNameRequired,
            .textTooShort
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textfield in
        textfield.accessibilityLabel = "cardNameField"
    }

    lazy var expiryDateField = MangoPayTextfield(
        placeholderText: LocalizableString.CARD_EXPIRIY_PLACEHOLDER,
        keyboardType: .numberPad,
        returnKeyType: .next,
        validationRule: [
            .cardExpired,
            .dateRequired
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ){ textfield in
        textfield.accessibilityLabel = "expiryDateField"
    }

    lazy var cvvField = MangoPayTextfield(
        placeholderText: LocalizableString.CARD_CVV,
        keyboardType: .numberPad,
        returnKeyType: .next,
        validationRule: [
            .cvvRequired,
            .textTooShort
        ],
        style: self.paymentFormStyle,
        textfieldDelegate: self
    ) { textfield in
        textfield.accessibilityLabel = "cvvField"
    }
    
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
    
    lazy var countryField = MangoPayDropDownTextfield(
        placeholderText: LocalizableString.CARD_COUNTRY_PLACEHOLDER,
        showDropDownIcon: true,
        style: self.paymentFormStyle,
        textfieldDelegate: self
    )

    lazy var zipCodeField = MangoPayTextfield(
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

    lazy var orPayWith = UILabel.create(
        text: "Or pay with",
        font: .systemFont(
            ofSize: 15,
            weight: .light
        ),
        textAlignment: .center
    )

    lazy var firstNameTextfield = MangoPayDropDownTextfield(
        placeholderText: LocalizableString.CARD_COUNTRY_PLACEHOLDER,
        showDropDownIcon: true,
        style: self.paymentFormStyle,
        textfieldDelegate: self
    )

    lazy var lastNameTextfield = MangoPayTextfield(
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

    lazy var addressLine1Field = MangoPayTextfield(
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

    lazy var addressLine2Field = MangoPayTextfield(
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

    lazy var cityAddressField = MangoPayTextfield(
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

    lazy var stateField = MangoPayTextfield(
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
        switch formType {
        case .dropIn:
            button.setTitle("Checkout \(dropInOptions?.amountString ?? "")", for: .normal)
        case .element:
            button.setTitle("Checkout \(elementOptions?.amountString ?? "")", for: .normal)
        }
        return button
    }()

    lazy var applePayButton: PKPaymentButton = {
        let appleButton = PKPaymentButton(
            paymentButtonType: .plain,
            paymentButtonStyle: .black
        )
        appleButton.cornerRadius = 8
        appleButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        appleButton.titleLabel?.font = .systemFont(ofSize: 2)
        appleButton.addTarget(
            self,
            action: #selector(onApplePayBtnTapped),
            for: .touchUpInside
        )
        
        return appleButton
    }()

    lazy var activitySpiner = UIActivityIndicatorView()
    
    var expiryMonth: Int?
    var expiryYear: Int?

    var tapGesture: UIGestureRecognizer?
    var formType: FormType = .dropIn
    var onApplePayTapped: (() -> ())?

    private lazy var vStack = UIScrollView.createWithVStack(
        spacing: 8,
        alignment: .fill,
        distribution: .fill,
        padding: UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0),
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
            orPayWith,
            applePayButton,
            statusLabel
        ]
    ) { stackView in
        stackView.setCustomSpacing(16, after: self.headerView)
        stackView.setCustomSpacing(24, after: self.checkMarkStack)
        stackView.setCustomSpacing(8, after: self.billingInfoTitle)
        stackView.setCustomSpacing(16, after: self.zipCodeField)
        stackView.setCustomSpacing(8, after: self.paymentButton)
        stackView.setCustomSpacing(8, after: self.orPayWith)
        stackView.setCustomSpacing(32, after: self.applePayButton)
    }

    var keyboardUtil: KeyboardUtil?
    var topConstriant: NSLayoutConstraint!
    var viewModel: PaymentFormViewModel!
    var onRightButtonTappedAction: (() -> Void)?
    var onClosedTapped: (() -> Void)?
    
    var dropInOptions: DropInOptions?
    var elementOptions: ElementsOptions?
    
    var paymentFormStyle: PaymentFormStyle
    var currentAttempt: String?
    
    lazy var forms: [Validatable] = [
        cardNumberField,
        cardNameField,
        expiryDateField,
        cvvField
    ]

    init(
        paymentFormStyle: PaymentFormStyle?,
        formType: FormType,
        dropInOptions: DropInOptions? = nil,
        elementOptions: ElementsOptions? = nil
    ) {
        self.formType = formType
        self.dropInOptions = dropInOptions
        self.elementOptions = elementOptions

        self.paymentFormStyle = paymentFormStyle ?? PaymentFormStyle()
        self.viewModel = PaymentFormViewModel(
            clientId: MangoPaySDK.clientId,
            apiKey: MangoPaySDK.apiKey,
            environment: (elementOptions?.environment ?? dropInOptions?.environment) ?? .sandbox
        )
    
        super.init(frame: .zero)
        tapGesture = UIGestureRecognizer(
            target: self,
            action: #selector(onViewTap)
        )
        
        setupView()
        setNavigation()
        loadCountries()
        
        keyboardUtil = KeyboardUtil(
            original: self.topConstriant.constant,
            padding: 0
        )
        keyboardUtil?.delegate = self
        keyboardUtil?.register()
        activitySpiner.isHidden = true
        
        cardNumberField.text = "4970105181818183"
        cardNameField.text = "Elikem"
//        cvvField.text = "120"
//        expiryDateField.text = "12/26"
        
        cardNumberField.onEditingChanged = { text in
            let cardType = CardTypeChecker.getCreditCardType(cardNumber: text)
            self.cardNumberField.setRightImage(cardType.icon)
        }

        countryField.didPickHandler = { title, index in
            self.viewModel.dropInDelegate?.didUpdateBillingInfo(sender: self.viewModel)
        }
        initiateNethone()
    }
    
    func initiateNethone() {
//        NTHNethone.setMerchantNumber("428242");
//        let nethoneConfig = NTHAttemptConfiguration()
//        nethoneConfig.sensitiveFields = [
//            "cardNumberField",
//            "cardNameField",
//            "expiryDateField",
//            "cvvField"
//        ]
//
//        registerTextfieldsToNethone()
//
//        do {
//            try NTHNethone.beginAttempt(with: nethoneConfig)
//            currentAttempt = NTHNethone.attemptReference()
//            print("✅ currentAttempt", currentAttempt)
//        } catch {
//            print("Nethone intiation Error")
//        }
    }

    func registerTextfieldsToNethone() {
//        NTHNethone.register(
//            cardNumberField.textfield,
//            mode: .AllData,
//            name: "cardNumberField"
//        )
//
//        NTHNethone.register(
//            cardNameField.textfield,
//            mode: .AllData,
//            name: "cardNameField"
//        )
//
//        NTHNethone.register(
//            expiryDateField.textfield,
//            mode: .AllData,
//            name: "expiryDateField"
//        )
//
//        NTHNethone.register(
//            cvvField.textfield,
//            mode: .AllData,
//            name: "cvvField"
//        )
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
        self.bringSubviewToFront(activitySpiner)
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

    func setNavigation() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))
        self.addSubview(navBar)

        let navItem = UINavigationItem(title: "SomeTitle")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: #selector(closeTapped))
        navItem.rightBarButtonItem = doneItem

        navBar.setItems([navItem], animated: false)
    }

    @objc func closeTapped() {
        onClosedTapped?()
    }

    @objc func onViewTap() {
        self.endEditing(true)
    }

    @objc func onTappedButton() {
        finalizeButtonTapped()
    }

    func finalizeButtonTapped() {
//        do {
//            try NTHNethone.finalizeAttempt(completion: { error in
//                guard error == nil else {
//                    // Handle finalization error.
//                    // For example: internet is down
//                    print("NTHNethone Error")
//                    return
//                }
//                // All data has been delivered to Nethone. Do the actual payment processing
                self.grabData()
//            })
//        } catch { error
//            print("❌❌❌❌ finalizeAttempt", error)
//        }
    }

    @objc func onApplePayBtnTapped() {
        onApplePayTapped?()
    }

    func grabData() {
        let formData = CardData(
            number: cardNumberField.text?.replacingOccurrences(of: " ", with: ""),
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
        
        let billingInfo = BillingInfo(
            line1: "j153",
            line2: "Prickasd",
            city: "accra",
            postalCode: "GH 21331",
            state: "Accra",
            country: "Ghana"
        )

        var customer = Customer(
            billingAddress: billingInfo,
            description: "Happy Customer",
            email: "elviva96@gmail.com",
            name: "Elikem Savie",
            phone: "0545543521",
            shippingAddress: ShippingAddress(
                address: billingInfo,
                name: "Elikem",
                phone: "Accra"
            ),
            company: Company(name: "File", number: "+233542442442")
        )

//        customer.billingAddress = billingInfo
//        customer.description = "Happy Customer"
//        customer.email = "elviva96@gmail.com"
//        customer.name = "Elikem Savie"
//        customer.phone = "0545543521"
//        let shippingAddress = ShippingAddress(
//            address: billingInfo,
//            name: "Elikem",
//            phone: "Accra"
//        )
//        customer.shippingAddress = shippingAddress
//        customer.company = Company(name: "File", number: "+233542442442")
        
        let cusInput = CustomerInputData(card: formData, customer: customer)
    

        Task {
            activitySpiner.isHidden = false
            activitySpiner.startAnimating()
            viewModel.onComplete = {
                self.activitySpiner.stopAnimating()
            }
            switch formType {
            case .dropIn:
//                await viewModel.performDropin(with: formData.toPaymentCardInput(), cardToken: nil)
                await viewModel.performDropinPayIn(with: formData.toPaymentCardInput())
            case .element:
                await viewModel.tokenizeCard()
            }
//            activitySpiner.stopAnimating()
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
            
            let cardType = CardTypeChecker.getCreditCardType(
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
        let moveBy = rect.height - safeAreaInsets.bottom - padding - 120
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
            self.viewModel.dropInDelegate?.didUpdateBillingInfo(sender: self.viewModel)
            isFormValid(zipCodeField)
        default: break
        }
    }
    

}

extension PaymentFormView: FormValidatable {
    
}
