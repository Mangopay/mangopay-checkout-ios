//
//  ConfigurationController.swift
//  MangoPayExampleCheckout
//
//  Created by Elikem Savie on 19/04/2023.
//

import UIKit
import MangoPayCoreiOS
import MangoPayVault
import MangoPaySdkAPI

public enum SDKProvier: String, CaseIterable {
    case WhenThen
    case Payline
}

enum SDKType: String, CaseIterable {
    case DropIn
    case DropInCustom = "Drop-In-Custom-Button"
    case Element
    case Vault
}

public enum Currency: String, CaseIterable {
    case euro = "EUR"
    case dollars = "USD"
    case britishPounds = "GBP"
}

public struct Configuration {
    var sdkMode: SDKProvier
    var apiKey: String
    var clientId: String
    var authorId: String?
    var userId: String
    var walletId: String?
    var amount: Double
    var currency: Currency

    public init(sdkMode: SDKProvier, apiKey: String, clientId: String, authorId: String? = nil, userId: String, walletId: String?, amount: Double, currency: Currency) {
        self.sdkMode = sdkMode
        self.apiKey = apiKey
        self.clientId = clientId
        self.authorId = authorId
        self.userId = userId
        self.walletId = walletId
        self.amount = amount
        self.currency = currency
    }
}

class ConfigurationController: UIViewController {

    lazy var forms: [Validatable] = [
        apiKeyField,
        clientField,
        authorField,
        creditedUserField,
        creditedWalletField,
        amountField,
    ]

    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!

    lazy var providerTextfield = MangoPayDropDownTextfield(
        placeholderText: "SDK Mode",
        showDropDownIcon: true,
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )

    lazy var apiKeyField = MangoPayTextfield(
        placeholderText: "API Key",
        returnKeyType: .next,
        validationRule: [
            .fieldRequired,
            .textTooShort
        ],
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )
    
    lazy var clientField = MangoPayTextfield(
        placeholderText: "Client ID",
        returnKeyType: .next,
        validationRule: [
            .fieldRequired,
            .textTooShort
        ],
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )

    lazy var authorField = MangoPayTextfield(
        placeholderText: "Author ID",
        returnKeyType: .next,
        validationRule: [
            .fieldRequired,
            .textTooShort
        ],
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )

    lazy var creditedUserField = MangoPayTextfield(
        placeholderText: "Credited User ID",
        returnKeyType: .next,
        validationRule: [
            .fieldRequired,
            .textTooShort
        ],
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )

    lazy var creditedWalletField = MangoPayTextfield(
        placeholderText: "Credited Wallet ID",
        returnKeyType: .next,
        validationRule: [
            .fieldRequired,
            .textTooShort
        ],
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )

    lazy var amountField = MangoPayTextfield(
        placeholderText: "Amount - Long Format",
        keyboardType: .decimalPad,
        returnKeyType: .next,
        validationRule: [
            .fieldRequired
        ],
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )
    
    lazy var currencyField = MangoPayDropDownTextfield(
        placeholderText: "Currency",
        showDropDownIcon: true,
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )

    private lazy var vStack = UIScrollView.createWithVStack(
        spacing: 8,
        alignment: .fill,
        distribution: .fill,
        padding: UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0),
        views: [
            providerTextfield,
            apiKeyField,
            clientField,
            authorField,
            creditedUserField,
            creditedWalletField,
            amountField,
            currencyField,
            paymentButton
        ]
    ) { stack in
        stack.setCustomSpacing(16, after: self.providerTextfield)
        stack.setCustomSpacing(16, after: self.currencyField)
    }

    lazy var paymentButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .purple
        button.setTitle("Initialise", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onTappedButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoader(false)
        setupUI()
        setupData()
        setDummyData()
    }
    
    func setupUI() {
        view.addSubview(vStack)
        
        vStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32).isActive = true
        vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }

    func showLoader(_ show: Bool) {
        activityLoader.isHidden = !show
        if show {
            activityLoader.startAnimating()
        } else {
            activityLoader.stopAnimating()
        }
    }

    @objc func onTappedButton() {
        guard areFormsValidShowingError() else { return }
        guard let configData = grabData() else { return }
        
        createCardReg(configuration: configData)
        
    }

    func setupData() {
        providerTextfield.update(with: SDKProvier.allCases.map({$0.rawValue}))
        currencyField.update(with: Currency.allCases.map({$0.rawValue}))
    }

    func grabData() -> Configuration? {
        
        guard let prov = providerTextfield.text, !prov.isEmpty else {
            providerTextfield.errorText = "Field Required"
            return nil
        }

        guard let cur = currencyField.text, !cur.isEmpty else {
            currencyField.errorText = "Field Required"
            return nil
        }

        guard let apiKeyStr = apiKeyField.text,
              let clientIDStr = clientField.text,
              let userIdStr = creditedUserField.text,
              let amountStr = amountField.text
        else { return nil }

        return Configuration(
            sdkMode: SDKProvier(rawValue: prov)!,
            apiKey: apiKeyStr,
            clientId: clientIDStr,
            authorId: authorField.text,
            userId: userIdStr,
            walletId: creditedWalletField.text,
            amount: Double(amountStr)!,
            currency: Currency(rawValue: cur)!
        )
    }
        
    func performCreateCardReg(
        cardReg: CardRegistration.Initiate,
        clientId: String,
        apiKey: String
    ) async -> CardRegistration? {
        do {
            showLoader(true)

            let regResponse = try await CardRegistrationClient(
                url: Environment.sandbox.url
            ).createCardRegistration(
                cardReg,
                clientId: clientId,
                apiKey: apiKey
            )
            showLoader(false)

            return regResponse
        } catch {
            print("❌ Error Creating Card Registration")
            showLoader(false)
            return nil
        }

    }

    func createCardReg(configuration: Configuration) {
        Task {
            if let createdObj = await performCreateCardReg(
                cardReg: CardRegistration.Initiate(
                    UserId: configuration.userId,
                    Currency: configuration.currency.rawValue,
                    CardType: "CB_VISA_MASTERCARD"),
                clientId: configuration.clientId,
                apiKey: configuration.apiKey
            ) {
                    
                switch configuration.sdkMode {
                case .Payline:
                    routeToDemoForm(cardRegistration: createdObj, config: configuration)
                case .WhenThen:
                    routeToWhenThenDemo()
                }
            }
        }
    }

    func setDummyData() {
        apiKeyField.text = "Su6k6UaeyXCpnMqZb0vHQzJ2ozyRXT6X5SsCPh20W29KueuVZ3"
        clientField.text = "12345"
        creditedUserField.text = "6658353"
        creditedWalletField.text = "6658354"
        authorField.text = "6658353"
    }

}

extension ConfigurationController: FormValidatable {
    
}

extension ConfigurationController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case apiKeyField.textfield:
            clientField.setResponsder()
        case clientField.textfield:
            authorField.setResponsder()
        case authorField.textfield:
            creditedUserField.setResponsder()
        case creditedUserField.textfield:
            creditedWalletField.setResponsder()
        case creditedWalletField.textfield:
            currencyField.setResponsder()
        case currencyField.textfield:
            self.view.endEditing(true)
        default: break
        }
        return true
    }
    
}

extension ConfigurationController: SegueHandlerType {
    enum SegueIdentifier: String {
        case segueToDemoForm
        case segueToWhenThen
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .segueToDemoForm:
            guard let destination = segue.destination as? DemoPaymentForm else { return }
            if let tuple = sender as? (CardRegistration, Configuration) {
                destination.cardRegistration = tuple.0
                destination.configuration = tuple.1
            }
        case .segueToWhenThen: break
            
        }
    }

    func routeToDemoForm(cardRegistration: CardRegistration, config: Configuration) {
        performSegueWithIdentifier(
            segueIdentifier: .segueToDemoForm,
            sender: (cardRegistration, config)
        )
    }

    func routeToWhenThenDemo() {
        performSegueWithIdentifier(segueIdentifier: .segueToWhenThen, sender: nil)
    }
}
