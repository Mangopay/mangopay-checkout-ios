//
//  ProductListController.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 09/12/2022.
//

import UIKit
import MangopayCoreiOS
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
        let viewController = ElementCardController(
            cardRegistration: config.cardReg,
            clientId: config.config.clientId
        )
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
     func didTapDropInCheckout(selectedProduct: Product) {
         let contact = PKContact()
         contact.name = .init(givenName: "Elikem", familyName: "Savie")
         
         let applePayConfig = MangopayApplePayConfig(
            amount: 1,
            delegate: self,
            merchantIdentifier: config.config.merchantID,
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

        checkout = MGPPaymentSheet.create(
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
                     self.handle3DS(with: cardRegistration.cardID ?? "") { can3DS in
                         if can3DS {
                             DispatchQueue.main.async {
                                 self.showAlert(with: "3DS succesful", title: "🎉 Payment complete")
                             }
                         } else {
                             DispatchQueue.main.async {
                                 self.checkout.tearDown {
                                     self.navigationController?.popToRootViewController(animated: true)

                                     topmostViewController?.showAlert(with: cardRegistration.cardID ?? "", title: "✅ cardRegistration")
                                 }

                             }
                         }
                     }
                 }, onPaymentCompleted: {
                     print("✅ onPaymentCompleted")
                 }, onCancelled: {
                     
                 },
                 onError: { error in
                     print("❌ error", error.reason)
//                     DispatchQueue.main.async {
                         topmostViewController?.showAlert(with: error.reason, title: "Error")
//                     }
                 },
                 onSheetDismissed: {
                     print("✅ sheet dismisses")
                 }
             )
         )

         checkout.present(in: self)
    }

    func handle3DS(with cardId: String, onSuccess: ((Bool) -> Void)? ) {
        
        let payInObj = AuthorizePayIn(
            tag: "Mangopay Demo Tag",
            authorID: config.config.userId,
            creditedUserID: config.config.userId,
            debitedFunds: DebitedFunds(currency: "EUR", amount: 10),
            fees: DebitedFunds(currency: "EUR", amount: 1),
            creditedWalletID: config.config.walletId ?? "",
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
                    env: .t3
                ).authorizePayIn(
                    payInObj,
                    clientId: config.config.clientId,
                    apiKey: config.config.apiKey
                )
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
