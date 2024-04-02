//
//  MangoPayElementsUI.swift
//  
//
//  Created by Elikem Savie on 25/05/2023.
//

#if os(iOS)
import UIKit
#endif
import NethoneSDK
import MangopayVaultSDK

public class MGPPaymentForm: UIView, FormValidatable {

    lazy var headerView = HeaderView()

    lazy var cardNumberField = MangoPayTextfield(
        placeholderText: "Card number",
        leftImage: UIImage(systemName: "creditcard"),
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
        textfield.accessibilityLabel = "cardNumberField"
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
            .dateRequired,
            .dateExpired,
            .dateInFuture
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

    lazy var privacyView = PrivacyView()

    private lazy var hStack = UIStackView.create(
        spacing: 8,
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        views: [expiryDateField, cvvField]
    )

    private lazy var vStack = UIScrollView.createWithVStack(
        spacing: 8,
        alignment: .fill,
        distribution: .fill,
        padding: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0),
        views: [
            headerView,
            cardNumberField,
            cardNameField,
            hStack,
            privacyView
        ]
    ) {
        stackview in
        stackview.setCustomSpacing(4, after: self.hStack)
    }

    lazy public var forms: [Validatable] = [
        cardNumberField,
        cardNameField,
        expiryDateField,
        cvvField
    ]

    var topConstriant: NSLayoutConstraint!
    var tapGesture: UIGestureRecognizer?
    var paymentFormStyle: PaymentFormStyle
    var keyboardUtil: KeyboardUtil?

    var expiryMonth: Int?
    var expiryYear: Int?

    var onRightButtonTappedAction: (() -> Void)?
    var didEndEditing: ((MGPPaymentForm) -> Void)?

    
    var cardRegistration: MGPCardRegistration?

    var cardType: CardType?

    var isFormValid: Bool {
        guard let cardNumber = cardNumberField.text?.trimCard() else { return false }
        return areFormsValidShowingError() && LuhnChecker.luhnCheck(cardNumber)
    }

    public var cardData: MGPCardInfo {
        let monStr = (expiryMonth ?? 0) < 10 ? ("0" + String(expiryMonth ?? 0)) : String(expiryMonth ?? 0)
        let expStr = monStr + String(expiryYear ?? 0).suffix(2)

        return MGPCardInfo(
            cardNumber: cardNumberField.text?.trimCard(),
            cardExpirationDate: expStr,
            cardCvx: cvvField.text,
            cardType: "CB_VISA_MASTERCARD"
        )
    }

    public init(
        paymentFormStyle: PaymentFormStyle?,
        supportedCardBrands: [CardType]? = nil,
        callBack: MangopayTokenizedCallBack? = nil
    ) {

        self.paymentFormStyle = paymentFormStyle ?? PaymentFormStyle()

        super.init(frame: .zero)
        tapGesture = UIGestureRecognizer(
            target: self,
            action: #selector(onViewTap)
        )
        
        setupView()
        setCards(cards: CardConfig(supportedCardBrands: supportedCardBrands))
        initiateNethone()
        
        cardNumberField.onEditingChanged = { text in
            self.cardType = CardTypeChecker.getCreditCardType(cardNumber: text)
            self.cardNumberField.setLeftImage(self.cardType?.icon)
        }
    
        privacyView.didTapPrivacyAction = {
            guard let webVC = WebViewController.openWebView(with: "https://mangopay.com/privacy-statement") else { return }
            topmostViewController?.present(webVC, animated: true)
        }
        
        cardNumberField.text = "4970105181818183"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(vStack)

        self.layer.cornerRadius = 8
        vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        vStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        vStack.heightAnchor.constraint(equalToConstant: 350).isActive = true

        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc func onViewTap() {
        self.endEditing(true)
    }

    func clearForm() {
        [
           cardNumberField,
           cardNameField,
           expiryDateField,
           cvvField
        ].forEach({$0.textfield.text = ""})
    }

    func manuallyValidateForms() {
        [
           cardNumberField,
           cardNameField,
           expiryDateField,
           cvvField
        ].forEach({isFormValid($0)})
    }

    private func setCards(cards: CardConfig?) {
        headerView.set(cards)
    }

    public func setCardNumber(_ cardNumber: String?) {
        cardNumberField.textfield.text = cardNumber
    }

    func setCardRegistration(_ cardRegistration: MGPCardRegistration?) {
        self.cardRegistration = cardRegistration
    }

    func initiateNethone() {
        let nethoneConfig = NTHAttemptConfiguration()
        nethoneConfig.registeredTextFieldsOnly = true

        registerTextfieldsToNethone()

        do {
            try NTHNethone.beginAttempt(with: nethoneConfig)
        } catch { error
            print("Nethone intiation Error", error.localizedDescription)
        }
    }

    func registerTextfieldsToNethone() {
        NTHNethone.register(
            cardNumberField.textfield,
            mode: .ContentFree,
            name: "cardNumberField"
        )

        NTHNethone.register(
            cardNameField.textfield,
            mode: .ContentFree,
            name: "cardNameField"
        )

        NTHNethone.register(
            expiryDateField.textfield,
            mode: .ContentFree,
            name: "expiryDateField"
        )

        NTHNethone.register(
            cvvField.textfield,
            mode: .ContentFree,
            name: "cvvField"
        )
    }

    func tokenizeCard(callBack: @escaping MangopayTokenizedCallBack) {
        guard self.isFormValid else {
            callBack(nil, MGPError.invalidForm)
            return
        }

        guard let attemptRef = NTHNethone.attemptReference() else {
            callBack(nil, MGPError.nethoneAttemptReferenceRqd)
            return
        }

        guard let cardReg = cardRegistration else {
            callBack(nil, MGPError.cardRegistrationNotSet)
            return
        }

        Tokenizer.tokenize(
            card: self.cardData,
            with: cardReg.toVaultCardReg,
            nethoeAttemptedRef: attemptRef
        ) { tokenizedCardData, error in
            callBack(tokenizedCardData, error)
        }

    }
}

extension MGPPaymentForm: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cardNumberField.textfield:
            cardNameField.setResponsder()
        case cardNameField.textfield:
            expiryDateField.setResponsder()
        case expiryDateField.textfield:
            cvvField.setResponsder()
        case cvvField.textfield:
            self.endEditing(true)
        default: break
        }

        return true
    }

    public func textField(
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

            let cardType = CardTypeChecker.getCreditCardType(
                cardNumber: text.trimCard()
            )
            cardNumberField.setLeftImage(cardType.icon)

            if text.count >= 4 && text.count <= cardType.cardCount && !string.isBackspace {
                var newString = ""
                for i in stride(from: 0, to: text.count, by: 4) {
                    let upperBoundIndex = i + 4
                    
                    let lowerBound = String.Index.init(encodedOffset: i)
                    let upperBound = String.Index.init(encodedOffset: upperBoundIndex)
                    
                    if upperBoundIndex <= text.count {
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
            
            if text.count > cardType.cardCount {
                return false
            }
            

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

    private func expDateValidation(dateStr: String) {

        guard let actualDate = Date(dateStr, format: "MM/yy") else { return }
        let enteredYear = Calendar.current.dateComponents([.year], from: actualDate).year ?? 0
        let enteredMonth = Calendar.current.dateComponents([.month], from: actualDate).month ?? 0

        self.expiryMonth = enteredMonth
        self.expiryYear = enteredYear

    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case cardNumberField.textfield:
            isFormValid(cardNumberField)
        case cardNameField.textfield:
            isFormValid(cardNameField)
        case expiryDateField.textfield:
            isFormValid(expiryDateField)
        case cvvField.textfield:
            isFormValid(cvvField)
        default: break
        }
        didEndEditing?(self)
    }
}

