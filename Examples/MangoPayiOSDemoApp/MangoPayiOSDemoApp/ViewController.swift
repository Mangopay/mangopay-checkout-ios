//
//  ViewController.swift
//  CheckoutiOSDemoApp
//
//  Created by Elikem Savie on 01/12/2022.
//

import UIKit
import MongoPayCoreiOS
import MongoPaySdkAPI
import MongoPayIntent
import MangoPayVault

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapElementCheckout(_ sender: UIButton) {
        let cardConfig = CardConfig(supportedCardBrands: [.visa, .amex])
                            
        let style = PaymentFormStyle(
            font: .systemFont(ofSize: 10),
            borderType: .round,
            backgroundColor: .red,
            textColor: .black,
            placeHolderColor: .gray,
            errorColor: .red,
            checkoutButtonTextColor: .white,
            checkoutButtonBackgroundColor: .black
        )
        
        let elementOptions = ElementsOptions(
            apiKey: "ct_test_kpOoHuu5pSzJGABP",
            style: style,
            customerId: nil,
            amount: 200,
            countryCode: "US",
            currencyCode: "USD",
            delegate: self
        )

        MongoPaySDK.buildElementForm(
            with: elementOptions,
            cardConfig: cardConfig,
            present: self
        )
    }
    
    @IBAction func didTapDropInCheckout(_ sender: Any) {
        let cardConfig = CardConfig(supportedCardBrands: [.visa, .amex])

        let style = PaymentFormStyle(
            font: .systemFont(ofSize: 18),
            backgroundColor: .red,
            textColor: .black,
            placeHolderColor: .gray,
            errorColor: .red
        )
        
        let dropInOptions = DropInOptions(
            apiKey: "ct_test_kpOoHuu5pSzJGABP",
            orderId: nil,
            style: style,
            customerId: nil,
            flowId: "c23700cf-25a9-4b80-8aa6-3e3169f6d896",
            amount: 2000,
            currencyCode: "EUR",
            countryCode: "US",
            delegate: self
        )
  
        
        MongoPaySDK.buildDropInForm(
            with: dropInOptions,
            cardConfig: cardConfig,
            present: self,
            dropInDelegate: self
        )
    }

    @IBAction func didTapPayline(_ sender: UIButton) {

        let resObj = CardRegistration(
            id: "163585699",
            creationDate: 1677743338,
            userID: "158091557",
            accessKey: "1X0m87dmM2LiwFgxPLBJ",
            preregistrationData: "ObMObfSdwRfyE4QClGtUc4qM8dLio0rp1vE4zmvS-FGYMCuEiVEd26Hn9C20q7Ka2ddFLVXdicolcUIkv_kKEA",
            cardType: "CB_VISA_MASTERCARD",
            cardRegistrationURLStr: "https://homologation-webpayment.payline.com/webpayment/getToken",
            currency: "EUR",
            status: "CREATED"
        )

        let cardInfo = CardInfo(
            accessKeyRef: resObj.accessKey,
            data: resObj.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )

        MangoPayVault().tokenisePaymentMethod(
            clientId: "checkoutsquatest",
            with: cardInfo,
            cardRegistration: resObj,
            delegate: self
        )
    }

    func startIntent() {
        Task {
            do  {
                let client = WhenThenClient(clientKey: "ct_test_KOShHY5fj7Zoh35l")
                
                let data = try await client.startIntent(
                    trackingId: UUID().uuidString,
                    flowId: "c23700cf-25a9-4b80-8aa6-3e3169f6d896"
                )
            } catch {
                //error
            }
        }
    }

}

extension ViewController: MangoPayVaultDelegate {
    
    func onSuccess(card: MongoPaySdkAPI.CardRegistration) {
        print("✅ Succesfull", card)
    }
    
    func onFailure(error: Error) {
        print("✅ failed", error)
    }
    
    
}

extension ViewController: DropInFormDelegate {

    func didUpdateBillingInfo(sender: PaymentFormViewModel) {
        
    }

    func onPaymentStarted(sender: PaymentFormViewModel) {
        
    }
    
    func onApplePayCompleteDropIn(status: WhenThenApplePay.PaymentStatus) {
        
    }
    

    func onPaymentCompleted(sender: PaymentFormViewModel, payment: GetPayment) {
        print("❤️ onPaymentCompleted \(payment)")
//        self.showAlert(with: payment.id, title: "Payment Succesfully Completed")
    }

    func onPaymentFailed(sender: PaymentFormViewModel, error: MongoPayError) {
        print("❌ onPaymentFailed \(error)")
    }
    
}

extension ViewController: ElementsFormDelegate {

    func onPaymentStarted(sender: PaymentFormViewModel, payment: GetPayment) {
        
    }
    
    func onApplePayCompleteElement(status: WhenThenApplePay.PaymentStatus) {
        
    }
    

    func onTokenGenerated(tokenisedCard: TokeniseCard) {
        print("Element Token Succesfully Generated \(tokenisedCard.token)")
        self.showAlert(with: tokenisedCard.token, title: "Tokenised Card")
    }
    
    func onTokenGenerationFailed(error: Error) {
        print("❌❌❌")
        print("Element Token Failed")
    }
   
}

extension ViewController {
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
