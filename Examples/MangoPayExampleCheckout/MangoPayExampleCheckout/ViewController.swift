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
        
        let formVC = ElementCardController(clientId: "checkoutsquatest")
        self.present(formVC, animated: true)
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
        
        let mgpClient = MangopayClient(
            clientId: "checkoutsquatest",
            apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC",
            environment: .sandbox
        )

        Task {
            guard let cardRegistration = await performCreateCardReg(
                cardReg: MGPCardRegistration.Initiate(
                    UserId: "158091557",
                    Currency: "EUR",
                    CardType: "CB_VISA_MASTERCARD"
                ),
                clientId: "checkoutsquatest",
                apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC"
            ) else {
                return
            }
            
            let checkout = MGPPaymentSheet.create(
                client: mgpClient,
                paymentMethodConfig: PaymentMethodConfig(
                    cardReg: cardRegistration
                ),
                handlePaymentFlow: false,
                branding: PaymentFormStyle(),
                callback: CallBack(
                    onPaymentMethodSelected: { paymentMethod in
                        print("✅ cardinfo", paymentMethod)
                    },
                    onTokenizationCompleted: { cardRegistration in
                        print("✅ cardRegistration", cardRegistration)
                        topmostViewController?.showAlert(with: cardRegistration.cardID ?? "", title: "✅ cardRegistration")
                    }, onPaymentCompleted: {
                        print("✅ onPaymentCompleted")
                    }, onCancelled: {
                        
                    },
                    onError: { error in
                        print("❌ error", error.reason)
                        self.showAlert(with: error.reason, title: "Error")
                    },
                    onSheetDismissed: {
                        print("✅ sheet dismisses")
                    }
                )
            )
            
            checkout.present(in: self)
        }
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
        
        MangopayVault.initialize(clientId: "checkoutsquatest", environment: .sandbox)

        MangopayVault.tokenizeCard(
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
    
    func performCreateCardReg(
        cardReg: MGPCardRegistration.Initiate,
        clientId: String,
        apiKey: String
    ) async -> MGPCardRegistration? {
        do {
//            showLoader(true)

            let regResponse = try await PaymentCoreClient(
                env: .sandbox
            ).createCardRegistration(
                cardReg,
                clientId: clientId,
                apiKey: apiKey
            )
//            showLoader(false)
            print("✅ res", regResponse)
            return regResponse
        } catch {
            print("❌ Error Creating Card Registration")
//            showLoader(false)
            return nil
        }

    }
}


extension UIViewController {
    func showAlert(with cardToken: String, title: String) {
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

var topmostViewController: UIViewController? {
    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
    while let controller = rootViewController?.presentedViewController {
        rootViewController = controller
    }
    return rootViewController
}
