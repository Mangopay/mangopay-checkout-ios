//
//  ViewController.swift
//  MangopayDemo
//
//  Created by Elikem Savie on 08/08/2023.
//

import UIKit
import MangopayCheckoutSDK
import MangopayVaultSDK

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
        self.navigationController?.pushViewController(formVC, animated: true)
//        self.present(formVC, animated: true)
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
            
            var checkout = MGPPaymentSheet.create(
                paymentMethodConfig: PaymentMethodOptions(
                    cardReg: cardRegistration
                ),
                handlePaymentFlow: false,
                branding: PaymentFormStyle(),
                callback: CallBack(
                    onPaymentMethodSelected: { paymentMethod in
                        print("✅ cardinfo", paymentMethod)
                        return
                    },
                    onTokenizationCompleted: { cardRegistration in
                        print("✅ cardRegistration", cardRegistration)
//                        topmostViewController?.showAlert(with: cardRegistration.cardID ?? "", title: "✅ cardRegistration")
                        self.handle3DS(with: cardRegistration.card.cardID ?? "") {
                            self.showAlert(with: "3DS succesful", title: "🎉 Payment complete")
                        }
                    }, onPaymentCompleted: { _, _ in
                        print("✅ onPaymentCompleted")
<<<<<<< HEAD
                    }, onCancel: {
=======
                    },
                    onCancelled: {
>>>>>>> checkout-release-readiness
                        
                    },
                    onError: { error in
                        print("❌ error", error.reason)
                        self.showAlert(with: error.reason, title: "Error")
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

    func handle3DS(with cardId: String, onSuccess: (() -> Void)? ) {
        
        let payInObj = AuthorizePayIn(
            tag: "Mangopay Demo Tag",
            authorID: "158091557",
            creditedUserID: "158091557",
            debitedFunds: Amount(currency: "EUR", amount: 10),
            creditedFunds: Amount(currency: "EUR", amount: 10),
            fees: Amount(currency: "EUR", amount: 1),
            creditedWalletID: "159834019",
            cardID: cardId,
            secureModeReturnURL: "https://docs.mangopay.com/please-ignore",
            secureModeRedirectURL: "https://docs.mangopay.com/please-ignore",
            statementDescriptor: "MANGOPAY",
            browserInfo: BrowserInfo(
                acceptHeader: "text/html, application/xhtml+xml, application/xml;q=0.9, /;q=0.8",
                javaEnabled: false,
                language: "EN-EN",
                colorDepth: 4,
                screenHeight: 750,
                screenWidth: 400,
                timeZoneOffset: 60,
                userAgent: "iOS",
                javascriptEnabled: false
            ),
            ipAddress: "3277:7cbf:b669:746b:cf75:08f8:061d:1867",
            billing: Ing(firstName: "eli", lastName: "Sav", address: Address(addressLine1: "jko", addressLine2: "234", city: "accra", region: "GR", postalCode: "23300", country: "France")),
            shipping: Ing(firstName: "DAF", lastName: "FEAM", address: Address(addressLine1: "DASD", addressLine2: "sff", city: "Paris", region: "Paris", postalCode: "23300", country: "France"))
        )
        
        Task {
            
            do {
                let regResponse = try await PaymentCoreClient(
                    env: .sandbox
                ).authorizePayIn(
                    payInObj,
                    clientId: "checkoutsquatest",
                    apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC"
                )
                //            showLoader(false)
                print("✅ res", regResponse)
                
                guard let payinData = regResponse as? Payable else { return }

                MangopayCheckoutSDK.launch3DSIfPossible(payData: payinData, presentIn: self) { success in
                    print("✅ launch3DSIfPossible", success)
                    onSuccess?()
                } on3DSFailure: { error in
                    print("error", error)
                    
                }
            } catch {
                print("❌ Error Creating Card Registration")
                //            showLoader(false)
            }
            
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
