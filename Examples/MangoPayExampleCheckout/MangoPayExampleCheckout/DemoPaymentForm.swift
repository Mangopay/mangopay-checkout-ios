//
//  DemoPaymentForm.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 20/03/2023.
//

import UIKit
import MangoPayVault
import MangoPaySdkAPI
import MangoPayIntent
import MangoPayVault

class DemoPaymentForm: UIViewController {
    
    @IBOutlet weak var cardNumberTextfield: UITextField!
    @IBOutlet weak var cvvTextfield: UITextField!
    @IBOutlet weak var expiryTextfield: UITextField!
    
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
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
        let card = grabData()
        payline(card: card)
    }
    
    @IBAction func didTapPayWT(_ sender: UIButton) {
        let card = grabDataMGP()
        mgpTokenise(card: card)
        
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
            clientId: "ct_test_9i8jZIEdWnTI4rsu",
            provider: .WHENTHEN
        )

        showLoader(true)
        mgpVault.tokeniseCard(card: cardInfo, whenThenDelegate: self)
    }
    
    func grabData() -> CardInfo {
        var card = CardInfo()
        card.cardNumber = cardNumberTextfield.text
        card.cardCvx = cvvTextfield.text
        card.cardExpirationDate = "0224"
        return card
    }

    func grabDataMGP() -> CardData {
        var card = CardData(
            number: "4970101122334422",
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
        
        let resObj = CardRegistration(
            id: "164747858",
            creationDate: 1679320385,
            userID: "158091557",
            accessKey: "1X0m87dmM2LiwFgxPLBJ",
            preregistrationData: "pMUiqKEKexdo_NolxfBziXiNDy4f6lZFLr2ONrDmqw-AZdAtiS8ON_lZopm5b8Er2ddFLVXdicolcUIkv_kKEA",
            cardType: "CB_VISA_MASTERCARD",
            cardRegistrationURLStr: "https://homologation-webpayment.payline.com/webpayment/getToken",
            currency: "EUR",
            status: "CREATED"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            cardRegistration: resObj,
            provider: .MANGOPAY
        )
        
        showLoader(true)
        
        mgpVault.tokeniseCard(
            card: card,
            paylineDelegate: self
        )
    }

    func mgpTokenise(card: CardData) {
        let mgpVault = MangoPayVault(
            clientId: "ct_test_TAb7Sb6fmXqTplUH",
            provider: .WHENTHEN
        )

        showLoader(true)
        mgpVault.tokeniseCard(card: card, whenThenDelegate: self)
    }
}

extension DemoPaymentForm: MangoPayVaultWTTokenisationDelegate {
    
    func onSuccess(tokenisedCard: MangoPaySdkAPI.TokeniseCard) {
        showLoader(false)
        showAlert(with: tokenisedCard.id, title: "Successful 🎉")
        
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

