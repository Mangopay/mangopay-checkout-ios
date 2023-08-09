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

    lazy var elementForm: MangoPayCheckoutForm = {
       let form = MangoPayCheckoutForm(paymentFormStyle: PaymentFormStyle())
        form.translatesAutoresizingMaskIntoConstraints = false
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
            
            MangoPayCoreiOS.tokenizeCard(
                form: elementForm,
                with: cardRegistration) { respoonse, error in
                    self.showLoader(false)
                    
                    if let res = respoonse {
                        self.showAlert(with: res.card.cardID ?? "", title: "🎉 Successful")
                        self.resultLabel.text = res.str
                    }
                    
                    if let err = error {
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

    func showLoader(_ status: Bool) {
        activityIndicator.isHidden = !status
        if status {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

