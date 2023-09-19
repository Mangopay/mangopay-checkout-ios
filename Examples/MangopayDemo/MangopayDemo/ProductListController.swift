//
//  ProductListController.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 09/12/2022.
//

import UIKit
import MangoPayCoreiOS
import MangoPaySdkAPI
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
    let apikey = "zFSxUNrqFc2TYTPaCb2Ki0dXy3qMWGu7mqnbC4W6V2UTSnXaSb"
//    let clientKey = "ct_test_LVB7OyjnVO8ZJ236"
    let flowID = "c1241bd1-9c7f-4371-a087-c03434434610"
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
    var config: DataCapsule!
    var checkout: MGPPaymentSheet!

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
//        let cardConfig = CardConfig(supportedCardBrands: [.visa, .amex])
//                            
//        let style = PaymentFormStyle(
//            font: .systemFont(ofSize: 10),
//            borderType: .round,
//            textColor: .black,
//            placeHolderColor: .gray,
//            errorColor: .red,
//            checkoutButtonTextColor: .white,
//            checkoutButtonBackgroundColor: .black
//        )
//        
//        let elementOptions = ElementsOptions(
//            apiKey: "ct_test_aSk3Ht5l9aCdjSaI",
//            clientId: "",
//            style: style,
//            customerId: nil,
//            amount: selectedProduct.price,
//            countryCode: "US",
//            currencyCode: "USD",
//            delegate: self
//        )
//
//        MangoPaySDK.buildElementForm(
//            with: elementOptions,
//            cardConfig: cardConfig,
//            present: self
//        )

        let viewController = ElementCardController(
            cardRegistration: config.cardReg,
            clientId: config.config.clientId
        )
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
//        present(viewController, animated: true)
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
     func didTapDropInCheckout(selectedProduct: Product) {

//         startIntent(amount: Int(selectedProduct.price))

         let mgpClient = MangopayClient(
            clientId: config.config.clientId,
             apiKey: config.config.apiKey,
             environment: .sandbox
         )
     
         let contact = PKContact()
         contact.name = .init(givenName: "Elikem", familyName: "Savie")
         
         let applePayConfig = MangopayApplePayConfig(
            amount: 1,
            delegate: self,
            merchantIdentifier: "merchant.mangopay.com.payline.58937646344908",
            merchantCapabilities: .capability3DS,
            currencyCode: "USD",
            countryCode: "US",
            supportedNetworks: [
                .amex,
                .discover,
                .masterCard,
                .visa
            ],
            requiredBillingContactFields: [.name],
            billingContact: contact,
            shippingType: .delivery
         )

        checkout = MGPPaymentSheet.create(
             client: mgpClient,
             paymentMethodConfig: PaymentMethodConfig(
                 cardReg: config.cardReg,
                 applePayConfig: applePayConfig
             ),
             handlePaymentFlow: false,
             branding: PaymentFormStyle(),
             callback: CallBack(
                 onPaymentMethodSelected: { paymentMethod in
                     print("✅ cardinfo", paymentMethod)
                 },
                 onTokenizationCompleted: { cardRegistration in
                     print("✅ cardRegistration", cardRegistration)
                     //                     topmostViewController?.showAlert(with: cardRegistration.cardID ?? "", title: "✅ cardRegistration")
                     self.handle3DS(with: cardRegistration.cardID ?? "") { can3DS in
                         if can3DS {
                             DispatchQueue.main.async {
                                 self.showAlert(with: "3DS succesful", title: "🎉 Payment complete")
                             }
                         } else {
                             DispatchQueue.main.async {
                                 topmostViewController?.showAlert(with: cardRegistration.cardID ?? "", title: "✅ cardRegistration")
                             }
                         }
                     }
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

    func startIntent(amount: Int) {
//        let intentClient = MangoPayIntent(clientKey: apikey)
//        let trackingId = UUID().uuidString
//        let amountInt = amount
//        Task {
//            do {
//                let indtentData = try await intentClient.startIntent(
//                    trackingId: trackingId,
//                    flowId: flowID,
//                    amount: MGPIntentAmountInput(amount: amountInt, currency: "USD"),
//                    location: MGPIntentLocationInput(country: "USA")
//                )
//                self.intentId = indtentData.id
//                MangoPaySDK.setIntentId(indtentData.id)
////                print("🤣 indtentData", indtentData)
//            } catch {
//                print("❌❌ Intent Error", error)
//            }
//
//        }
    }

    func handle3DS(with cardId: String, onSuccess: ((Bool) -> Void)? ) {
        
        let payInObj = AuthorizePayIn(
            tag: "Mangopay Demo Tag",
            authorID: "158091557",
            creditedUserID: "158091557",
            debitedFunds: DebitedFunds(currency: "EUR", amount: 10),
            fees: DebitedFunds(currency: "EUR", amount: 1),
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
            billing: Ing(firstName: "eli", lastName: "Sav", address: Address(addressLine1: "jko", addressLine2: "234", city: "Paris", region: "Ile-de-France", postalCode: "75001", country: "FR")),
            shipping: Ing(firstName: "DAF", lastName: "FEAM", address: Address(addressLine1: "DASD", addressLine2: "sff", city: "Paris", region: "Ile-de-France", postalCode: "75001", country: "FR"))
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
                
                guard let payinData = regResponse as? PayInPreAuthProtocol else { return }

                MGPPaymentSheet().launch3DSIfPossible(payData: payinData, presentIn: self) { success in
                    print("✅ launch3DSIfPossible", success)
                    onSuccess?(true)
                } on3DSLauch: { _3dsVC in
                    DispatchQueue.main.async {
                        self.checkout.tearDown()
                        self.navigationController?.pushViewController(_3dsVC, animated: true)
                    }
                } on3DSFailure: { error in
                    print("error", error)
                    switch error {
                    case ._3dsNotRqd:
                        onSuccess?(false)
                    default: break
                    }
                    
                }
            } catch {
                print("❌ Error Creating Card Registration")
                //            showLoader(false)
            }
            
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
            self.didTapDropInCheckout(selectedProduct: prod)
        }))
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
           ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
           present(ac, animated: true)
    }
    
}

extension ProductListController: MGPApplePayHandlerDelegate {

    func applePayContext(didSelect shippingMethod: PKShippingMethod, handler: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        print("✅ shippingMethod", shippingMethod)
    }

    func applePayContext(didCompleteWith status: MangoPayApplePay.PaymentStatus, error: Error?) {
        print("✅ status", status)

    }
    
    
}
