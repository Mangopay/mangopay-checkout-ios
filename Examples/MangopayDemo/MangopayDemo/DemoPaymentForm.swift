//
//  DemoPaymentForm.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 20/03/2023.
//

import UIKit
import MangopayVaultSDK
import MangopayCheckoutSDK

class DemoPaymentForm: UIViewController {
    
    @IBOutlet weak var cardNumberTextfield: UITextField!
    @IBOutlet weak var cvvTextfield: UITextField!
    @IBOutlet weak var expiryTextfield: UITextField!
    
    @IBOutlet weak var mmExpiryField: UITextField!
    @IBOutlet weak var yyExpiryField: UITextField!
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    var configuration: Configuration!
    var cardRegistration: CardRegistration!
    var createdPayIn: AuthorizePayIn?
    
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
    
    @IBAction func didTapAuthorize(_ sender: UIButton) {
        guard let _card = cardRegistration else { return }
        peformAuthorize(with: _card)
    }
    
    @IBAction func didTapGetPayIn(_ sender: UIButton) {
        guard let _createdPayIn = createdPayIn else { return }
        peformGetPayIn()
    }
    
    @IBAction func didTapListCard(_ sender: Any) {
        guard let _createdPayIn = createdPayIn else { return }
        getCustomerCards()
    }
    
    @IBAction func didTapPayWT(_ sender: UIButton) {
    }
    
    func createCardReg(
        cardReg: MGPCardRegistration.Initiate,
        clientId: String,
        apiKey: String
    ) async -> MGPCardRegistration? {
        do {
            showLoader(true)
            
            let regResponse = try await PaymentCoreClient(
                env: .sandbox
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

    
    func peformAuthorize(with tokenisedCard: CardRegistration) {

    }
    
    func peformGetPayIn() {
    }

    func getCustomerCards() {
    }

    func payline(card: CardInfo) {
        MangopayVault.initialize(clientId: configuration.clientId, environment: .sandbox)

        showLoader(true)
        
        MangopayVault.tokenizeCard(
            card: CardInfo(
                cardNumber: card.cardNumber,
                cardExpirationDate: card.cardExpirationDate,
                cardCvx: card.cardCvx,
                cardType: card.cardType,
                accessKeyRef: card.accessKeyRef,
                data: card.data
            ),
            cardRegistration: cardRegistration) { tokenisedCard, error in
                guard let _ = tokenisedCard else {
                    print("✅ failed", error)
                    self.showLoader(false)
                    self.showAlert(with: error?.localizedDescription ?? "", title: "Failed ❌")
                    return
                }
                self.showLoader(false)
                self.showAlert(with: "", title: "Successful 🎉")
                self.cardRegistration = tokenisedCard
            }
    }
    
}
