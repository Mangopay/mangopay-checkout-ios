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

    init(cardRegistration: MGPCardRegistration, clientId: String) {
        super.init(nibName: nil, bundle: nil)
        self.cardRegistration = cardRegistration
        self.clientId = clientId
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapPay() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        MangoPaySDK.tokenizeCard(
            form: elementForm,
            with: cardRegistration.toVaultCardReg
        ) { respoonse, error in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true

                if let res = respoonse {
                    self.showAlert(with: res.card.cardID ?? "", title: "🎉 Successful")
                    self.resultLabel.text = res.str
                }

                if let err = error {
                    self.showAlert(with: err.localizedDescription, title: "❌ Error")

                }
            }
    }

}

extension ElementCardController {
    private func showAlert(with cardToken: String, title: String) {
        let alert = UIAlertController(
            title: title,
            message: cardToken,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
