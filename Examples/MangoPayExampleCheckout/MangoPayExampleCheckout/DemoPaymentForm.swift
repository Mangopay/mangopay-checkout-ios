//
//  DemoPaymentForm.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 20/03/2023.
//

import UIKit
import MangoPayVault
import MangoPaySdkAPI
//import MangoPayIntent
import MangoPayVault

class DemoPaymentForm: UIViewController {
    
    @IBOutlet weak var cardNumberTextfield: UITextField!
    @IBOutlet weak var cvvTextfield: UITextField!
    @IBOutlet weak var expiryTextfield: UITextField!
    
    @IBOutlet weak var mmExpiryField: UITextField!
    @IBOutlet weak var yyExpiryField: UITextField!
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    var configuration: Configuration!
    var cardRegistration: CardRegistration!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        showLoader(false)
        
    }
    
    func showLoader(_ show: Bool) {
        activityMonitor.isHidden = !show
        if show {
            activityMonitor.startAnimating()
        } else {
            activityMonitor.stopAnimating()
        }
    }
    
    @IBAction func didTapPay(_ sender: UIButton) {
        guard let card = grabData() else {
            return
        }
        payline(card: card)
    }
    
    @IBAction func didTapPayWT(_ sender: UIButton) {
        let card = grabDataMGP()
        mgptokenize(card: card)
        
        let cardInfo = CardData(
            number: "4970101122334422",
            name: "Visa",
            expMonth: 6,
            expYear: 26,
            cvc: "123",
            savePayment: false,
            bilingInfo: nil
        )

        let mgpVault = MangoPayVault(
            clientId: configuration.clientId,
            provider: .WHENTHEN,
            environment: .sandbox
        )

        showLoader(true)
        mgpVault.tokenizeCard(card: cardInfo, whenThenDelegate: self)
    }

    func createCardReg(
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
    
    func grabData() -> CardInfo? {

        guard let cardNum = cardNumberTextfield.text,
              let cvv = cvvTextfield.text,
              let month = mmExpiryField.text,
              let year = yyExpiryField.text else { return nil }
        
        let expStr = month + year
        
        return CardInfo(
            cardNumber: cardNum,
            cardExpirationDate: expStr,
            cardCvx: cvv
       )
    }

    func grabDataMGP() -> CardData {
        var card = CardData(
            number: "497010711111119",
            name: "Visa",
            expMonth: 6,
            expYear: 26,
            cvc: "123",
            savePayment: false,
            bilingInfo: nil
        )
           
        return card
    }
    
    func payline(card: CardInfo) {
        
//        let resObj = CardRegistration(
//            id: "164747858",
//            creationDate: 1679320385,
//            userID: "158091557",
//            accessKey: "1X0m87dmM2LiwFgxPLBJ",
//            preregistrationData: "pMUiqKEKexdo_NolxfBziXiNDy4f6lZFLr2ONrDmqw-AZdAtiS8ON_lZopm5b8Er2ddFLVXdicolcUIkv_kKEA",
//            cardType: "CB_VISA_MASTERCARD",
//            cardRegistrationURLStr: "https://homologation-webpayment.payline.com/webpayment/getToken",
//            currency: "EUR",
//            status: "CREATED"
//        )
        
  
        
//        return CardData(
//            number: cardNum,
//            name: "Visa",
//            expMonth: Int(month),
//            expYear: Int(year),
//            cvc: cvv,
//            savePayment: false,
//            bilingInfo: nil
//        )

        let mgpVault = MangoPayVault(
            clientToken: configuration.clientId,
            cardRegistration: cardRegistration,
            provider: .MANGOPAY,
            environment: .sandbox
        )
        
        showLoader(true)
        
        mgpVault.tokenizeCard(
            card: card,
            paylineDelegate: self
        )
    }

    func mgptokenize(card: CardData) {
        let mgpVault = MangoPayVault(
            clientId: configuration.clientId,
            provider: .WHENTHEN, environment: .sandbox
        )

        showLoader(true)
        mgpVault.tokenizeCard(card: card, whenThenDelegate: self)
    }
}

extension DemoPaymentForm: MangoPayVaultWTTokenisationDelegate {
    
    func onSuccess(tokenizedCard: MangoPaySdkAPI.tokenizeCard) {
        showLoader(false)
        showAlert(with: tokenizedCard.id, title: "Successful 🎉")
        
    }
    
}

extension DemoPaymentForm: MangoPayVaultDelegate {
    
    func onSuccess(card: MangoPaySdkAPI.CardRegistration) {
        showLoader(false)
        showAlert(with: card.accessKey ?? "", title: "Successful 🎉")
    }
    
    func onFailure(error: Error) {
        print("✅ failed", error)
        showLoader(false)
        showAlert(with: error.localizedDescription, title: "Failed ❌")

    }
    
    
}


extension DemoPaymentForm {
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

