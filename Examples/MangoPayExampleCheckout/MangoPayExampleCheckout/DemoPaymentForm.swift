//
//  DemoPaymentForm.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 20/03/2023.
//

import UIKit
import MangopayVault
import MangoPaySdkAPI
//import MangoPayIntent

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
            
            let regResponse = try await CardRegistrationClient(
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
    
    func peformAuthorize(with tokenisedCard: CardRegistration) {
        showLoader(true)
        
        let client = MangoPayClient(
            clientKey: "checkoutsquatest",
            apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC",
            environment: .sandbox
        )
        
        Task {
            let authPay = AuthorizePayIn(
                tag: tokenisedCard.tag ?? "Random tag",
                authorID: "158091557",
                creditedUserID: "158091557",
                debitedFunds: DebitedFunds(currency: "EUR", amount: 20),
                fees: DebitedFunds(currency: "EUR", amount: 2),
                creditedWalletID: "159834019",
                cardID: tokenisedCard.cardID ?? "" ,
                secureModeReturnURL: "https://docs.mangopay.com/please-ignore",
                statementDescriptor: "MangoPay",
                browserInfo: BrowserInfo(),
                ipAddress: "1c10:17fe:65db:25b7:1784:ce36:43ce:c610",
                shipping: Ing(firstName: "Elikem", lastName: "Savie", address: Address(addressLine1: "Accra", addressLine2: "Ghana", city: "Accra", region: "Accra", postalCode: "00000", country: "FR")
                             )
                
            )
            do {
                let payIn = try await client.authorizePaymentPayIn(payment: authPay)
                print("✅ success", payIn)
                self.createdPayIn = payIn
                showLoader(false)
                self.showAlert(with: payIn.id ?? "", title: "Successfully Authorized Card 🎉")
                
            } catch {
                print("❌ error", error)
                showLoader(false)
                self.showAlert(with: "", title: "❌ Authorized Card Failed")
            }
        }
    }
    
    func peformGetPayIn() {
        guard let payId = createdPayIn?.id else { return }
        let client = MangoPayClient(
            clientKey: "checkoutsquatest",
            apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC",
            environment: .sandbox
        )
        
        Task {
            do {
                let payIn = try await client.getPayIn(payInId: payId)
                DispatchQueue.main.async {
                    self.showAlert(with: payIn.cardID ?? "lol", title: "Successful 🎉")
                }
            } catch {
                print("❌ error", error)
            }
        }
    }

    func getCustomerCards() {
        guard let payId = createdPayIn?.id else { return }
        let client = MangoPayClient(
            clientKey: "checkoutsquatest",
            apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC",
            environment: .sandbox
        )
        
        Task {
            do {
                let payIn = try await client.listPayInCards(userId: "158091557", isActive: true)
                let cards = payIn.compactMap({$0.id}).joined(separator: ",")
                DispatchQueue.main.async {
                    self.showAlert(with: cards, title: "Cards 🎉")
                }
            } catch {
                print("❌ error", error)
            }
        }
    }

    func payline(card: CardInfo) {
        MangoPayVault.initialize(clientId: configuration.clientId, environment: .sandbox)

        showLoader(true)
        
        MangoPayVault.tokenizeCard(
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

