//
//  ViewController.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 13/10/2022.
//

import UIKit
import MangoPayCoreiOS
import MangoPaySdkAPI
import MangoPayIntent
import MangoPayVault

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.isHidden = true
    }

    func showLoader(_ show: Bool) {
        activityIndicator.isHidden = !show
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
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

        MangoPaySDK.buildElementForm(
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
  
        
        MangoPaySDK.buildDropInForm(
            with: dropInOptions,
            cardConfig: cardConfig,
            present: self,
            dropInDelegate: self
        )
    }
/*
 clientToken => WT
 clientId => MGP
 
 init
 cardRegData(optional)
 
 remove CardData from init
 send it to tokenise
 
 func tokeniseCard(
 card: Cardable,
 
 
 */
    
    @IBAction func didTapPayline(_ sender: UIButton) {

        let resObj = CardRegistration(
            id: "164689525",
            creationDate: 1678862696,
            userID: "158091557",
            accessKey: "1X0m87dmM2LiwFgxPLBJ",
            preregistrationData: "-3qr8M0QBM0xs1g25H_bHhMzNE3s5pZbjCwLe75jdRSIeR1WXJq8WHOx0f4EWQuW2ddFLVXdicolcUIkv_kKEA",
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
        
        showLoader(true)
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
        )

        mgpVault.tokenise(
            card: cardInfo,
            cardRegistration: resObj,
            paylineDelegate: self
        )
    }

    @IBAction func didTapVaultWT(_ sender: UIButton) {
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
        mgpVault.tokenise(card: cardInfo, whenThenDelegate: self)

    }
    
}

extension ViewController: MangoPayVaultWTTokenisationDelegate {

    func onSuccess(tokenisedCard: MangoPaySdkAPI.TokeniseCard) {
        showLoader(false)
        showAlert(with: tokenisedCard.id, title: "Successful 🎉")

    }
    
}

extension ViewController: MangoPayVaultDelegate {
    
    func onSuccess(card: MangoPaySdkAPI.CardRegistration) {
        showLoader(false)
        showAlert(with: "", title: "Successful 🎉")
    }
    
    func onFailure(error: Error) {
        print("✅ failed", error)
        showLoader(false)
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

    func onPaymentFailed(sender: PaymentFormViewModel, error: MangoPayError) {
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
