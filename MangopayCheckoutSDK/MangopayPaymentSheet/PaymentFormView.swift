//
//  PaymentFormView.swift
//  
//
//  Created by Elikem Savie on 31/07/2023.
//

import UIKit
import PassKit

class PaymentFormView: UIView {

    public lazy var navView = NavView()

    private lazy var paymentForm: MGPPaymentForm = {
        let view = MGPPaymentForm(
            paymentFormStyle: paymentFormStyle,
            supportedCardBrands: supportedCardBrands
        )
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
       return view
    }()

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

    lazy var applePayButton: PKPaymentButton = {
        let appleButton = PKPaymentButton(
            paymentButtonType: paymentFormStyle.applePayButtonType,
            paymentButtonStyle: paymentFormStyle.applePayButtonStyle
        )
        appleButton.cornerRadius = paymentFormStyle.applePayButtonCornerRadius
        appleButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        appleButton.titleLabel?.font = .systemFont(ofSize: 2)
        appleButton.addTarget(
            self,
            action: #selector(onApplePayBtnTapped),
            for: .touchUpInside
        )
        
        return appleButton
    }()

    lazy var paymentButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = paymentFormStyle.checkoutButtonBackgroundColor
        button.setTitle(paymentFormStyle.checkoutButtonText, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onTappedButton), for: .touchUpInside)
        button.setTitleColor(paymentFormStyle.checkoutButtonTextColor, for: .normal)
        return button
    }()

    lazy var payPalButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .yellow
        button.setImage(UIImage(assetIdentifier: .paypal), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onPaypalButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var vStack = UIScrollView.createWithVStack(
        spacing: 8,
        alignment: .fill,
        distribution: .fill,
        padding: UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0),
        views: [
            navView,
            paymentForm,
            paymentButton,
            payPalButton,
            orPayWith,
            applePayButton,
            statusLabel
        ]
    ) { stackView in
        stackView.setCustomSpacing(8, after: self.paymentButton)
        stackView.setCustomSpacing(8, after: self.orPayWith)
        stackView.setCustomSpacing(32, after: self.applePayButton)
    }

    public var isFormValid: Bool {
        return paymentForm.isFormValid
    }
    
    var expiryMonth: Int?
    var expiryYear: Int?

    var tapGesture: UIGestureRecognizer?
    var onApplePayTapped: (() -> ())?

    var keyboardUtil: KeyboardUtil?
    var topConstriant: NSLayoutConstraint!
    var viewModel: PaymentFormViewModel!
    var onRightButtonTappedAction: (() -> Void)?
    var onClosedTapped: (() -> Void)?
    
    var paymentFormStyle: PaymentFormStyle
    var currentAttempt: String?
    var supportedCardBrands: [CardType]?

    var client: MangopayClient
    var callback: CallBack
    var paymentMethodConfig: PaymentMethodConfig
    var handlePaymentFlow: Bool

    init(
        client: MangopayClient,
        paymentMethodConfig: PaymentMethodConfig,
        handlePaymentFlow: Bool,
        branding: PaymentFormStyle?,
        supportedCardBrands: [CardType]? = nil,
        callback: CallBack
    ) {
        self.paymentFormStyle = branding ?? PaymentFormStyle()
        self.callback = callback
        self.client = client
        self.paymentMethodConfig = paymentMethodConfig
        self.supportedCardBrands = supportedCardBrands
        self.handlePaymentFlow = handlePaymentFlow
        
        self.viewModel = PaymentFormViewModel(
            client: client,
            paymentMethodConfig: paymentMethodConfig
        )

        super.init(frame: .zero)
        tapGesture = UIGestureRecognizer(
            target: self,
            action: #selector(onViewTap)
        )

        [orPayWith, applePayButton].forEach({$0.isHidden = !(paymentMethodConfig.applePayConfig?.shouldRenderApplePay == true)})

        setupView()

        viewModel.onTokenisationCompleted = {
            Loader.hide()
        }

        viewModel.onTokenisationError = { _ in
            Loader.hide()
        }

        navView.setTitle(paymentFormStyle.checkoutTitleText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        vStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        self.backgroundColor = .white
    }

    @objc func closeTapped() {
        onClosedTapped?()
        callback.onCancelled?()
    }

    @objc func onViewTap() {
        self.endEditing(true)
    }

    func clearForm() {
        paymentForm.clearForm()
    }

    func renderPayButton(isValid: Bool) {
        self.paymentButton.backgroundColor = isValid ? self.paymentFormStyle.checkoutButtonBackgroundColor : self.paymentFormStyle.checkoutButtonDisabledBackgroundColor
        self.paymentButton.isEnabled = isValid
    }

    public func setCardNumber(_ cardNumber: String?) {
        self.paymentForm.setCardNumber(cardNumber)
    }

    func manuallyValidateForms() {
        return paymentForm.manuallyValidateForms()
    }

    @objc func onTappedButton() {
        guard paymentForm.isFormValid else { return }
        finalizeButtonTapped()
        callback.onPaymentMethodSelected?(.card(paymentForm.cardData))
        Loader.show()
    }

    @objc func onPaypalButtonTapped() {
        callback.onPaymentMethodSelected?(.payPal)
//        Loader.show()
    }

    @objc func onApplePayBtnTapped() {
        onApplePayTapped?()
        callback.onPaymentMethodSelected?(.applePay(.none))
    }

    func finalizeButtonTapped() {
        viewModel.tokenizeCard(
            form: self.paymentForm,
            cardRegistration: paymentMethodConfig.cardReg,
            callback: callback
        )
    }
}

