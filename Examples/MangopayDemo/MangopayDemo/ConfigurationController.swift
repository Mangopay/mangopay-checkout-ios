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
    var clientId: String
    var amount: Double
    var currency: Currency
    var baseurlStr: String

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

    var backendURL: URL {
        return URL(string: baseurlStr)!
    }

    public init(
        sdkMode: SDKProvier,
        env: MGPEnvironment,
        cardFlowType: _3DSTransactionType?,
        clientId: String,
        amount: Double,
        currency: Currency,
        baseurlStr: String
    ) {
        self.sdkMode = sdkMode
        self.env = env
        self.cardFlowType = cardFlowType
        self.clientId = clientId
        self.amount = amount
        self.currency = currency
        self.baseurlStr = baseurlStr
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
        amountField
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
            envTextfield,
            cardFlowField,
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

        
        guard let amountStr = amountField.text else { return nil }
        
        let __env = MGPEnvironment(rawValue: env)!
        MangopayCheckoutSDK.initialize(
            clientId: clientId,
            profilingMerchantId: "428242",
            checkoutReference: UUID().uuidString,
            environment: __env
        )


        var cardFlowType: _3DSTransactionType?

        if let cardFlowStr = cardFlowField.text, !cardFlowStr.isEmpty {
            cardFlowType = _3DSTransactionType(rawValue: cardFlowStr)
        }

        return Configuration(
            sdkMode: .MangoPay,
            env: __env,
            cardFlowType: cardFlowType,
            clientId: clientId,
            amount: Double(amountStr)!,
            currency: Currency(rawValue: cur)!,
            baseurlStr: baseurl
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

    func setDummyData(env: MGPEnvironment?) {
        currencyField.text = "EUR"
        amountField.text = "1"
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
