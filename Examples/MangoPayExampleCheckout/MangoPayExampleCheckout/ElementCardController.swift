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

    lazy var elementForm: MangoPayElementsFormUI = {
       let form = MangoPayElementsFormUI(
        paymentFormStyle: PaymentFormStyle(),
        elementOptions: ElementsOptions(
            apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC",
            clientId: "checkoutsquatest",
            amount: 10,
            countryCode: "FR",
            currencyCode: "GH",
            delegate: self
        )
       )
        form.translatesAutoresizingMaskIntoConstraints = false
        return form
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(elementForm)

        elementForm.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        elementForm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        elementForm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        elementForm.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }

}

extension ElementCardController: ElementsFormDelegate {
    func onTokenGenerated(vaultCard: MangoPaySdkAPI.CardRegistration) {
        
    }
    
    func onPaymentStarted(sender: PaymentFormViewModel) {
        
    }

    func onTokenGenerated(tokenizedCard: TokenizeCard) {
        
    }
    
    func onTokenGenerationFailed(error: Error) {
        
    }
    
    func onPaymentStarted(sender: PaymentFormViewModel, payment: GetPayment) {
        
    }
    
}
