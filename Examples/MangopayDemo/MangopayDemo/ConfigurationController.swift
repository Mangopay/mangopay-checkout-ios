//
//  ConfigurationController.swift
//  MangoPayExampleCheckout
//
//  Created by Elikem Savie on 19/04/2023.
//

import UIKit
import MangopayCheckoutSDK
import MangopayVaultSDK
import Foundation

public enum SDKProvier: String, CaseIterable {
    case MangoPay
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
    case dirham = "AED"
    case australianDollar = "AUD"
    case canadianDollar = "CAD"
    case swissFranc = "CHF"
    case danishKrone = "DKK"
    case japaneseYen = "JPY"
    case norwegianKrone = "NOK"
    case polishZloty = "PLN"
    case swidishKrona = "SEK"
}

public struct Configuration {
    var sdkMode: SDKProvier
    var env: MGPEnvironment
    var cardFlowType: _3DSTransactionType?
    var apiKey: String
    var clientId: String
    var authorId: String?
    var userId: String
    var walletId: String?
    var amount: Double
    var currency: Currency

    var merchantID: String {
        switch env {
        case .sandbox, .t3:
            return "merchant.mangopay.com.payline.58937646344908"
        case .production:
            return "merchant.mangopay.com.payline.43461661979437"
        }
    }

    var formattedAmount: String {
        return currency.rawValue + " " + amount.formatAsCurrency
    }

    public init(sdkMode: SDKProvier, env: MGPEnvironment, cardFlowType: _3DSTransactionType?, apiKey: String, clientId: String, authorId: String? = nil, userId: String, walletId: String?, amount: Double, currency: Currency) {
        self.sdkMode = sdkMode
        self.env = env
        self.cardFlowType = cardFlowType
        self.apiKey = apiKey
        self.clientId = clientId
        self.authorId = authorId
        self.userId = userId
        self.walletId = walletId
        self.amount = amount
        self.currency = currency
    }
}

public struct DataCapsule {
    var config: Configuration
    var cardReg: MGPCardRegistration

    public init(config: Configuration, cardReg: MGPCardRegistration) {
        self.config = config
        self.cardReg = cardReg
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

    lazy var envTextfield = MangoPayDropDownTextfield(
        placeholderText: "Environment",
        showDropDownIcon: true,
        style: PaymentFormStyle(),
        textfieldDelegate: self
    )

    lazy var cardFlowField = MangoPayDropDownTextfield(
        placeholderText: "Card Flow Type",
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
//            providerTextfield,
            envTextfield,
            apiKeyField,
            clientField,
            cardFlowField,
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
        button.setTitle("Initialize", for: .normal)
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
        setDummyData(env: nil)
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
        
//        createCardReg(configuration: configData)
        
        routeToWhenThenDemo(config: configData)

        
    }

    func setupData() {
        providerTextfield.update(with: SDKProvier.allCases.map({$0.rawValue}))
        currencyField.update(with: Currency.allCases.map({$0.rawValue}))
        envTextfield.update(with: MGPEnvironment.allCases.map({$0.rawValue}))
        cardFlowField.update(with: _3DSTransactionType.allCases.map({$0.rawValue}))
    }

    func grabData() -> Configuration? {
        
//        guard let prov = providerTextfield.text, !prov.isEmpty else {
//            providerTextfield.errorText = "Field Required"
//            return nil
//        }

        guard let cur = currencyField.text, !cur.isEmpty else {
            currencyField.errorText = "Field Required"
            return nil
        }

        guard let env = envTextfield.text, !cur.isEmpty else {
            envTextfield.errorText = "Field Required"
            return nil
        }

        guard let clientId = getDataFromPlist()["CLIENT_ID"] as? String, !clientId.isEmpty else {
            envTextfield.errorText = "Set CLIENT_ID in plist file"
            return nil
        }

        guard let baseurl = getDataFromPlist()["EXAMPLE_BACKEND_URL"] as? String else {
            envTextfield.errorText = "Set EXAMPLE_BACKEND_URL in plist file"
            return nil
        }

        
        guard
//            let apiKeyStr = apiKeyField.text,
//              let clientIDStr = clientField.text,
//              let userIdStr = creditedUserField.text,
              let amountStr = amountField.text
        else { return nil }
        
        let __env = MGPEnvironment(rawValue: env)!
        MangopayCheckoutSDK.initialize(clientId: clientIDStr, profillingMerchantId: "428242", environment: __env)

        var cardFlowType: _3DSTransactionType?

        if let cardFlowStr = cardFlowField.text, !cardFlowStr.isEmpty {
            cardFlowType = _3DSTransactionType(rawValue: cardFlowStr)
        }

        return Configuration(
            sdkMode: .MangoPay,
            env: __env,
            cardFlowType: cardFlowType,
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
        cardReg: MGPCardRegistration.Initiate,
        config: Configuration,
        clientId: String,
        apiKey: String
    ) async -> MGPCardRegistration? {
        do {
            showLoader(true)

            let regResponse = try await PaymentCoreClient(
                env: config.env
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

//    func createCardReg(configuration: Configuration) {
//        Task {
//            if let createdObj = await performCreateCardReg(
//                cardReg: MGPCardRegistration.Initiate(
//                    UserId: configuration.userId,
//                    Currency: configuration.currency.rawValue,
//                    CardType: "CB_VISA_MASTERCARD"),
//                config: configuration,
//                clientId: configuration.clientId,
//                apiKey: configuration.apiKey
//            ) {
//                    
//                switch configuration.sdkMode {
//                case .Payline:
//                    routeToDemoForm(cardRegistration: createdObj, config: configuration)
//                case .MangoPay:
//                    routeToWhenThenDemo(config: DataCapsule(config: configuration, cardReg: createdObj))
//                }
//            } else {
//                activityLoader.stopAnimating()
//            }
//        }
//    }

    func setDummyData(env: MGPEnvironment?) {
        currencyField.text = "EUR"

        guard let _env = env else { return }
        switch _env {
        case .sandbox:
            apiKeyField.text = "6281f06d0ba54934a9747d9b7c9e8bb2"
            clientField.text = "checkoutsquatest"
            creditedUserField.text = "157868268"
            creditedWalletField.text = "159834019"
            authorField.text = "157868268"
            amountField.text = "1"
        case .production:
            apiKeyField.text = "FPuqRtn4A6LhH7JGJ9QUDSfc3M0aTsbiQfScW8boGyfaAD57h3"
            clientField.text = "arthurinc"
            creditedUserField.text = "4234427192"
            creditedWalletField.text = "4234431137"
            authorField.text = "4234427192"
            amountField.text = "1"
        case .t3:
            apiKeyField.text = "8b35136d29a4430983c835f81caf7c05"
            clientField.text = "valitoreurprodtest2"
            
            creditedUserField.text = "user_m_01HP6Y728NHC46PTAT186AM17V"
            creditedWalletField.text = "wlt_m_01HP6Y7WB48TVZCQ2HQ7BH8KK9"
            
            authorField.text = "6664602"
            amountField.text = "1"
            
        }
    }

    func getDataFromPlist() -> [String: Any] {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
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

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case envTextfield.textfield:
            guard let env = envTextfield.text else {
                return
            }
            let selected = MGPEnvironment(rawValue: env)!
            setDummyData(env: selected)
        default: break
        }
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
            if let config = sender as? Configuration {
//                destination.cardRegistration = tuple.0
                destination.configuration = config
            }
        case .segueToWhenThen:
            guard let destination = segue.destination as? ProductListController else { return }
            if let tuple = sender as? Configuration {
                destination.config = tuple
            }
        }
    }

    func routeToDemoForm(config: Configuration) {
        performSegueWithIdentifier(
            segueIdentifier: .segueToDemoForm,
            sender: config
        )
    }

    func routeToWhenThenDemo(config: Configuration) {
        performSegueWithIdentifier(segueIdentifier: .segueToWhenThen, sender: config)
    }
}

var decimalFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = true
    formatter.decimalSeparator = "."
    formatter.currencyDecimalSeparator = "."
    formatter.groupingSeparator = ","
    formatter.currencyGroupingSeparator = ","
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter
}

extension Double {
    var formatAsCurrency: String {
        decimalFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
