//
//  ViewController.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 13/10/2022.
//

import UIKit
import MangoPayCoreiOS
import MangoPaySdkAPI
//import MangoPayIntent
import MangopayVault

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
            clientId: "",
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
            clientId: "",
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

        let cardInfo = MGPCardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        showLoader(true)
        
        MangoPayVault.initialize(clientId: "checkoutsquatest", environment: .sandbox)

        MangoPayVault.tokenizeCard(
            card: CardInfo(
                cardNumber: cardInfo.cardNumber,
                cardExpirationDate: cardInfo.cardExpirationDate,
                cardCvx: cardInfo.cardCvx,
                cardType: cardInfo.cardType,
                accessKeyRef: cardInfo.accessKeyRef,
                data: cardInfo.data
            ),
            cardRegistration: resObj) { tokenisedCard, error in
                guard let _ = tokenisedCard else {
                    print("✅ failed", error)
                    self.showLoader(false)
                    return
                }
                self.showLoader(false)
                self.showAlert(with: "", title: "Successful 🎉")
            }
    }

    @IBAction func didTapVaultWT(_ sender: UIButton) {

    }
    
}

extension ViewController: DropInFormDelegate {

    func didUpdateBillingInfo(sender: PaymentFormViewModel) {
        
    }

    func onPaymentStarted(sender: PaymentFormViewModel) {
        
    }
    
    func onApplePayCompleteDropIn(status: MangoPayApplePay.PaymentStatus) {
        
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
    func onTokenGenerated(vaultCard: MGPCardRegistration) {
        
    }
    

    func onPaymentStarted(sender: PaymentFormViewModel, payment: GetPayment) {
        
    }
    
    func onApplePayCompleteElement(status: MangoPayApplePay.PaymentStatus) {
        
    }
    

    func onTokenGenerated(tokenizedCard: TokenizeCard) {
        print("Element Token Succesfully Generated \(tokenizedCard.token)")
        self.showAlert(with: tokenizedCard.token, title: "tokenized Card")
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
