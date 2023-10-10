//
//  ElementCardController.swift
//  MangoPayExampleCheckout
//
//  Created by Elikem Savie on 25/05/2023.
//

import UIKit
import MangoPayCoreiOS
import MangoPaySdkAPI

class ElementCardController: UIViewController {
    
    var cardRegistration: MGPCardRegistration!
    var clientId: String!

    lazy var elementForm: MGPPaymentForm = {
        let form = MGPPaymentForm(
            paymentFormStyle: PaymentFormStyle(),
            supportedCardBrands: [.visa, .mastercard, .maestro]
        )
        return form
    }()

    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    lazy var checkoutButton: UIButton = {
        let but = UIButton()
        but.translatesAutoresizingMaskIntoConstraints = false
        but.heightAnchor.constraint(equalToConstant: 60).isActive = true
        but.backgroundColor = .blue
        but.setTitle("Pay", for: .normal)
        but.setTitleColor(.white, for: .normal)
        but.layer.cornerRadius = 8
        but.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
        return but
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(elementForm)
        self.view.addSubview(checkoutButton)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(resultLabel)

        self.view.backgroundColor = .orange

        elementForm.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        elementForm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        elementForm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true

        checkoutButton.topAnchor.constraint(equalTo: elementForm.bottomAnchor, constant: 30).isActive = true
        checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    
        resultLabel.topAnchor.constraint(equalTo: checkoutButton.bottomAnchor, constant: 60).isActive = true
        resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 10).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }

    init(cardRegistration: MGPCardRegistration? = nil, clientId: String) {
        super.init(nibName: nil, bundle: nil)
        self.cardRegistration = cardRegistration
        self.clientId = clientId
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapPay() {
        showLoader(true)

        Task {
            guard let cardRegistration = await performCreateCardReg(
                cardReg: MGPCardRegistration.Initiate(
                    UserId: "158091557",
                    Currency: "EUR",
                    CardType: "CB_VISA_MASTERCARD"
                ),
                clientId: "checkoutsquatest",
                apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC"
            ) else {
                showLoader(false)
                return
            }

//            let preAuth = PreAuthCard(
//                authorID: "158091557",
//                debitedFunds: DebitedFunds(currency: "EUR", amount: 10),
//                secureMode: "FORCE",
//                cardID: "nil",
//                secureModeNeeded: true,
//                secureModeRedirectURL: "https://docs.mangopay.com",
//                secureModeReturnURL: "https://docs.mangopay.com"
//            )

            MangopayCoreiOS.tokenizeCard(
                form: elementForm,
                with: cardRegistration,
                presentIn: self
            ) { respoonse, error in
                    self.showLoader(false)
                    
                    if let res = respoonse {
                        self.resultLabel.text = res.str ?? ""
                        self.handle3DS(with: res.card.cardID ?? "", onSuccess: {
                            self.showLoader(false)
                            self.showAlert(with: "3DS succesful", title: "🎉 Payment complete")
                        })
                    }
                    
                    if let err = error {
                        self.showLoader(false)
                        self.showAlert(with: err.reason, title: "❌ Error")
                    }
                }
        }
    }

    func performCreateCardReg(
        cardReg: MGPCardRegistration.Initiate,
        clientId: String,
        apiKey: String
    ) async -> MGPCardRegistration? {
        do {
//            showLoader(true)

            let regResponse = try await PaymentCoreClient(
                env: .sandbox
            ).createCardRegistration(
                cardReg,
                clientId: clientId,
                apiKey: apiKey
            )
//            showLoader(false)
            print("✅ res", regResponse)
            return regResponse
        } catch {
            print("❌ Error Creating Card Registration")
//            showLoader(false)
            return nil
        }

    }

    func handle3DS(with cardId: String, onSuccess: (() -> Void)? ) {
        
        let payInObj = AuthorizePayIn(
            tag: "Mangopay Demo Tag",
            authorID: "158091557",
            creditedUserID: "158091557",
            debitedFunds: DebitedFunds(currency: "EUR", amount: 10),
            fees: DebitedFunds(currency: "EUR", amount: 1),
            creditedWalletID: "159834019",
            cardID: cardId,
            secureModeReturnURL: "https://docs.mangopay.com/please-ignore",
            secureModeRedirectURL: "https://docs.mangopay.com/please-ignore",
            statementDescriptor: "MANGOPAY",
            browserInfo: BrowserInfo(
                acceptHeader: "text/html, application/xhtml+xml, application/xml;q=0.9, /;q=0.8",
                javaEnabled: false,
                language: "EN-EN",
                colorDepth: 4,
                screenHeight: 750,
                screenWidth: 400,
                timeZoneOffset: 60,
                userAgent: "iOS",
                javascriptEnabled: false
            ),
            ipAddress: "3277:7cbf:b669:746b:cf75:08f8:061d:1867",
            billing: Ing(firstName: "eli", lastName: "Sav", address: Address(addressLine1: "jko", addressLine2: "234", city: "Paris", region: "Ile-de-France", postalCode: "75001", country: "FR")),
            shipping: Ing(firstName: "DAF", lastName: "FEAM", address: Address(addressLine1: "DASD", addressLine2: "sff", city: "Paris", region: "Ile-de-France", postalCode: "75001", country: "FR"))
        )
        
        Task {
            
            do {
                let regResponse = try await PaymentCoreClient(
                    env: .sandbox
                ).authorizePayIn(
                    payInObj,
                    clientId: clientId,
                    apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC"
                )
                //            showLoader(false)
                print("✅ res", regResponse)
                
                guard let payinData = regResponse as? PayInPreAuthProtocol else { return }

                MangopayCoreiOS.launch3DSIfPossible(payData: payinData, presentIn: self) { success in
                    print("✅ launch3DSIfPossible", success)
                    onSuccess?()
                } on3DSFailure: { error in
                    print("error", error)
                    
                }
            } catch {
                print("❌ Error authorizePayIn", error.localizedDescription)
                //            showLoader(false)
            }
            
        }
        
    }

    func showLoader(_ status: Bool) {
        activityIndicator.isHidden = !status
        if status {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
