//
//  ViewController.swift
//  CheckoutiOSDemoApp
//
//  Created by Elikem Savie on 01/12/2022.
//

import UIKit
import checkout_ios_sdk

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
            environment: .sandbox,
            customerId: nil,
            delegate: self
        )

        WhenThenSDK.buildElementForm(
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
            environment: .sandbox,
            customerId: nil,
            flowId: "c23700cf-25a9-4b80-8aa6-3e3169f6d896",
            amount: 2000,
            currencyCode: "EUR",
            delegate: self
        )

        WhenThenSDK.buildDropInForm(
            with: dropInOptions,
            cardConfig: cardConfig,
            present: self,
            dropInDelegate: self
        )
    }

}

extension ViewController: DropInFormDelegate {

    func onPaymentCompleted(sender: PaymentFormViewModel, payment: GetPayment) {
        print("❤️ onPaymentCompleted \(payment)")
//        self.showAlert(with: payment.id, title: "Payment Succesfully Completed")
    }

    func onPaymentFailed(sender: PaymentFormViewModel, error: WhenThenError) {
        print("❌ onPaymentFailed \(error)")
    }
    
}

extension ViewController: ElementsFormDelegate {

    func onTokenGenerated(tokenisedCard: TokeniseCard) {
        print("😀😀😀")
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
