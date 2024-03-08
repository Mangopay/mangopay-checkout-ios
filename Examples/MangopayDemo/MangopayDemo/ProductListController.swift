//
//  ProductListController.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 09/12/2022.
//

import UIKit
import MangopayCheckoutSDK
import PassKit
//import MangoPayIntent

struct Product {
    let name: String
    let price: Float
    let imageName: String
    
    var amountString: String {
        let priceString = String(format: "$ %.02f", price)
        return priceString
    }
}

class ProductListController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var intentId = ""

    let productData = [
        Product(name: "Horizon West", price: 69.00, imageName: "horizon"),
        Product(name: "FIFA 23", price: 59.00, imageName: "fifa23"),
        Product(name: "COD MW2", price: 69.00,imageName: "codmw2")
//        Product(name: "COD MW", price: 69.00,imageName: "codmw"),
//        Product(name: "The Witcher", price: 69.00,imageName: "witcher"),
//        Product(name: "Spiderman", price: 69.00,imageName: "spiderman"),
//        Product(name: "God Of War", price: 69.00,imageName: "god"),
//        Product(name: "God Of War2", price: 69.00,imageName: "god2"),
//        Product(name: "Uncharted", price: 69.00,imageName: "uncharted"),
//        Product(name: "GTA 5", price: 59, imageName: "gta5"),
    ]

    var selectedProduct: Product?
    var config: Configuration!
    var checkout: MGPPaymentSheet!
    var cardId: String?

    @IBOutlet weak var priceAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(
            UINib(nibName: "ItemCell", bundle: nil),
            forCellWithReuseIdentifier: ItemCell.reuseId
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: #selector(closeTapped))
        self.navigationController?.navigationItem.setRightBarButton(closeButton, animated: true)
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true)
    }

    func didTapElementCheckout(selectedProduct: Product) {
        Task {
            let cardRegistration = await self.performCreateCardReg(
               cardReg: MGPCardRegistration.Initiate(
                   UserId: self.config.userId,
                   Currency: self.config.currency.rawValue,
                   CardType: "CB_VISA_MASTERCARD"),
               config: self.config,
               clientId: self.config.clientId,
               apiKey: self.config.apiKey
            )

            let viewController = ElementCardController(
                cardRegistration: cardRegistration,
                clientId: config.clientId
            )
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .coverVertical
            self.navigationController?.pushViewController(viewController, animated: true)
        }

    }
    
    func didTapPaymentSheet(selectedProduct: Product, shouldPerform3ds: Bool = true) {
         let contact = PKContact()
         contact.name = .init(givenName: "Elikem", familyName: "Savie")
         
         config.amount = Double(selectedProduct.price)
     
         let applePayConfig = MGPApplePayConfig(
            amount: Double(selectedProduct.price),
            delegate: self,
            merchantIdentifier: config.merchantID,
            merchantCapabilities: .capability3DS,
            currencyCode: "USD",
            countryCode: "US",
            supportedNetworks: [
                .masterCard,
                .visa
            ],
            requiredBillingContactFields: [.name],
            billingContact: contact,
            shippingType: .delivery
         )

        MangopayCheckoutSDK.apiKey = config.apiKey
        checkout = MGPPaymentSheet.create(
             paymentMethodConfig: PaymentMethodOptions(
                 cardReg: nil,
                 applePayConfig: applePayConfig,
                 paypalConfig: MGPPaypalConfig()
             ),
             handlePaymentFlow: false,
             branding: PaymentFormStyle(checkoutButtonText: "Pay " + config.formattedAmount, checkoutTitleText: "My Checkout"),
             supportedCardBrands: [.visa, .mastercard, .amex, .maestro, .cb],
             callback: CallBack(
                 onPaymentMethodSelected: { paymentMethod in
                     switch paymentMethod {
                     case .card(_):
                         return
                     case .applePay(_):
                         return
                     case .payPal:
                         return
                     }
                 },
                 onTokenizationCompleted: { cardRegistration in
                     print("✅ cardRegistration", cardRegistration)
                     self.cardId = cardRegistration.card.cardID
                 }, 
                 onCreateCardRegistration: { cardInfo in
                    guard let cardRegistration = await self.performCreateCardReg(
                       cardReg: MGPCardRegistration.Initiate(
                           UserId: self.config.userId,
                           Currency: self.config.currency.rawValue,
                           CardType: "CB_VISA_MASTERCARD"),
                       config: self.config,
                       clientId: self.config.clientId,
                       apiKey: self.config.apiKey
                    ) else { return nil }
                    return cardRegistration

                },
                 onPaymentCompleted: { id, results in
                     guard let res = results, let status = results?.status else { return }
                     
                     self.checkout.tearDown {
                         switch status {
                         case .SUCCEEDED:
                             self.showSuccessDialog(
                                title: "✅ Payment Completed",
                                result: res.id
                             )
                         case .FAILED, .CANCELLED:
                             self.showAlert(with: "", title: "Payment failed")
                         }
                     }
                 },
                 onCreatePayment: { paymentMethod, attemptRef in
                     
                     switch paymentMethod {
                     case .card(_):
                         guard let payInRes = await self.mockPayinEndpoint(
                            with: self.cardId ?? "",
                            attemptReference: attemptRef ?? ""
                         ) else { return nil }
                         return payInRes
                     case .applePay(_):
                         return nil
                     case .payPal:
                         guard let paypalResponse = await self.mockAndHandlePaypal(
                            attemptReference: attemptRef
                         ) else { return nil }
                         return paypalResponse
                     }
                 }, onCancelled: {
                     
                 },
                 onError: { error in
                         topmostViewController?.showAlert(with: error.reason, title: "Error")
                 }
             )
         )

         checkout.present(in: self)
    }

    func mockAndHandlePaypal(attemptReference: String?) async -> APMInfo? {
        let paypal = APMInfo(
            authorID: config.userId,
            debitedFunds: Amount(currency: "EUR", amount: 200),
            fees: Amount(currency: "EUR", amount: 0),
            creditedWalletID: config.walletId,
            returnURL: "https://github.com/?check=payin&env=\(config.env.rawValue)",
            shippingAddress: PPAddress(
                recipientName: "Elikem",
                address: Address(
                    addressLine1: "3 rue de la Feature",
                    addressLine2: "Bat. MGP",
                    city: "Paris",
                    region: "IDF",
                    postalCode: "75009",
                    country: "FR"
                )
            ),
            tag: "Postman create a payin paypal",
            culture: "fr",
            lineItems: [
                LineItem(
                    name: "running shoe 1",
                    quantity: 1,
                    unitAmount: 200,
                    taxAmount: 0,
                    description: "sub-seller information"
                    )
            ],
            shippingPreference: "GET_FROM_FILE",
            reference: "123-456",
            redirectURL: "https://github.com",
            profilingAttemptReference: attemptReference
        )
            
            do {
                let regResponse = try await PaymentCoreClient(
                    env: self.config.env
                ).createWebPayIn(
                    clientId: self.config.clientId,
                    apiKey: self.config.apiKey,
                    paypalData: paypal
                )
                return regResponse
            } catch {
                print("❌ payInpaypal Error ")
                return nil
            }
            
    }


    func performCreateCardReg(
        cardReg: MGPCardRegistration.Initiate,
        config: Configuration,
        clientId: String,
        apiKey: String
    ) async -> MGPCardRegistration? {
        do {
            let regResponse = try await PaymentCoreClient(
                env: config.env
            ).createCardRegistration(
                cardReg,
                clientId: clientId,
                apiKey: apiKey
            )

            return regResponse
        } catch {
            print("❌ Error Creating Card Registration")
            return nil
        }

    }

    func handle3DS(with cardId: String, onSuccess: ((Bool) -> Void)? ) {
        let validationObj = CardValidation(
            authorID: config.userId,
            tag: "Mangopay Demo Tag",
            debitedFunds: nil,
            secureMode: nil,
            cardID: cardId,
            secureModeRedirectURL: "https://docs.mangopay.com/please-ignore", secureModeReturnURL: "https://docs.mangopay.com/please-ignore",
            ipAddress: "3277:7cbf:b669:746b:cf75:08f8:061d:1867",
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
            )
        )


        Task {
            do {
                let regResponse = try await PaymentCoreClient(
                    env: config.env
                ).validateCard(validationObj, cardId: cardId, clientId: config.clientId, apiKey: config.apiKey)
                print("✅ res", regResponse)
                
                guard let payinData = regResponse as? Payable else { return }

                MGPPaymentSheet().launch3DSIfPossible(payData: regResponse, presentIn: self) { success in
                    print("✅ launch3DSIfPossible", success)
                    onSuccess?(true)
                } on3DSLauch: { _3dsVC in
                    DispatchQueue.main.async {
                        self.checkout.tearDown()
                        self.navigationController?.pushViewController(_3dsVC, animated: true)
                    }
                } on3DSFailure: { error in
                    DispatchQueue.main.async {
                        topmostViewController?.showAlert(with: "", title: "3DS challenge failed")

                    }
                } on3DSError: { error in
                    print("error", error)
                    switch error {
                    case ._3dsNotRqd:
                        onSuccess?(false)
                    default: break
                    }
                }
            } catch {
                print("❌ authorizePayIn Error Creating Card Registration")
                //            showLoader(false)
                onSuccess?(false)
            }
        }
    }

    func mockPreAuthValidateEndpoint(with cardId: String, attemptReference: String) async -> PreAuthCard? {
        
        let preAuth = PreAuthCard(
            authorID: self.config.userId,
            debitedFunds: Amount(currency: "EUR", amount: 20),
            cardID: cardId,
            secureModeNeeded: true,
            secureModeRedirectURL: "https://docs.mangopay.com/please-ignore", secureModeReturnURL: "https://docs.mangopay.com/please-ignore",
            ipAddress: "3277:7cbf:b669:746b:cf75:08f8:061d:1867",
            profilingAttemptReference: attemptReference
        )
        
        do {
            let regResponse = try await PaymentCoreClient(
                env: self.config.env
            ).createPreAuth(
                clientId: self.config.clientId,
                apiKey: self.config.apiKey,
                preAuth: preAuth
            )
            print("✅✅ preAuth", regResponse)
            return regResponse
        } catch {
            print("❌ preAuth error Creating preAuth", error)
            return nil
        }
    }

    func mockPayinEndpoint(with cardId: String, attemptReference: String) async -> AuthorizePayIn? {
        
        let payInObj = AuthorizePayIn(
            tag: "Mangopay Demo Tag",
            authorID: config.userId,
            creditedUserID: config.userId,
            debitedFunds: Amount(currency: "EUR", amount: 10),
            creditedFunds: nil,
            fees: Amount(currency: "EUR", amount: 0),
            creditedWalletID: config.walletId ?? "",
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
            billing: Ing(firstName: "eli", lastName: "Sav", address: Address(addressLine1: "jko", addressLine2: "234", city: "Paris", region: "Ile-de-France", postalCode: "75001", country: "FR")),
            shipping: Ing(firstName: "DAF", lastName: "FEAM", address: Address(addressLine1: "DASD", addressLine2: "sff", city: "Paris", region: "Ile-de-France", postalCode: "75001", country: "FR")),
            secureModeNeeded: true,
            profilingAttemptReference: attemptReference
        )
        
        do {
            let payIn = try await PaymentCoreClient(
                env: self.config.env
            ).authorizePayIn(
                payInObj,
                clientId: self.config.clientId,
                apiKey: self.config.apiKey
            )
            print("✅✅ payIn", payIn)
            return payIn
        } catch {
            print("❌ Payin failed", error)
            return nil
        }
    }
}


extension ProductListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseId, for: indexPath) as? ItemCell else {
            fatalError("Cell not found")
        }
        let prod = productData[indexPath.row]
        cell.configure(prod)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 64) / 2
        return CGSize(width: width, height: width * 1.34)
    }
    
}

extension ProductListController: ItemCellDelegate {

    func didTapBuy(sender: ItemCell) {
        guard let index = collectionView.indexPath(for: sender) else { return }
        let prod = productData[index.row]
        let ac = UIAlertController(title: "Checkout Options", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Payment Form", style: .default, handler: {_ in
            self.didTapElementCheckout(selectedProduct: prod)
        }))
        ac.addAction(UIAlertAction(title: "Payment Sheet", style: .default, handler: { _ in
            self.didTapPaymentSheet(selectedProduct: prod)
        }))
        ac.addAction(UIAlertAction(title: "Payment Sheet(3DS Only)", style: .default, handler: { _ in
            self.didTapPaymentSheet(selectedProduct: prod)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
}

extension ProductListController: MGPApplePayHandlerDelegate {

    func applePayContext(didSelect shippingMethod: PKShippingMethod, handler: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
    }

    func applePayContext(didCompleteWith status: MGPApplePay.PaymentStatus, error: Error?) {
        switch status {
        case .success(let token):
//            Loader
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
//                self.showSuccessDialog(title: "🤣 MangoPayApplePay.token", result: token)
                ResultView.show(title: "MangoPayApplePay.token", result: token)
//            })
        case .error:
            print("❌ MangoPayApplePay.error")
        case .userCancellation: break
            
        }
    }
    
    
}
