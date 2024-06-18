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
                   UserId: "",
                   Currency: self.config.currency.rawValue,
                   CardType: "CB_VISA_MASTERCARD"),
               config: self.config
            )

            let viewController = ElementCardController(
                cardRegistration: cardRegistration,
                config: config
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
     
         let applePayConfig = MGPApplePayOptions(
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

        checkout = MGPPaymentSheet.create(
            paymentMethodOptions: PaymentMethodOptions(
                 cardOptions: MGPCardOptions(supportedCardBrands: [.visa, .mastercard, .amex, .maestro, .cb]),
                 applePayOptions: applePayConfig,
                 paypalOptions: MGPPaypalOptions()
             ),
             branding: PaymentFormStyle(checkoutButtonText: "Pay " + config.formattedAmount, checkoutTitleText: "My Checkout"),
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
                           UserId: "",
                           Currency: self.config.currency.rawValue,
                           CardType: "CB_VISA_MASTERCARD"),
                       config: self.config
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
                         guard let payInRes = await self.makeEndpointCall(
                            acardfloType: self.config.cardFlowType ?? .cardDirect,
                            cardId: self.cardId ?? "",
                            profilAttempte: attemptRef ?? ""
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
                 }, onCancel: {
                     
                 },
                 onError: { error in
                         topmostViewController?.showAlert(with: error.reason, title: "Error")
                 }
             )
         )

         checkout.present(in: self)
    }

    func mockAndHandlePaypal(attemptReference: String?) async -> APMInfo? {
        do {
            let regResponse = try await PaymentCoreClient(
                env: self.config.env
            ).createPaypalViaGlitch(backendURl: config.backendURL)
            return regResponse
        } catch {
            print("❌ payInpaypal Error ")
            return nil
        }
    }

    func makeEndpointCall(acardfloType: _3DSTransactionType, cardId: String, profilAttempte: String) async -> AuthorizePayIn? {
        
        var path = ""
        switch acardfloType {
        case .cardDirect:
            path = "/create-card-direct-payin"
        case .preauthorized:
            path = "/create-card-preauth-payin"
        case .cardValidated:
            path = "/create-card-validation"
        case .depositPreAuth:
            path = "/create-card-deposit-preauth-payin"
        case .recurring:
            path = "/create-card-recurring-payin"
        }
        
        do {
            let cardFlow = try await PaymentCoreClient(
                env: self.config.env
            ).createCardFlows(cardID: cardId, profileAttempt: profilAttempte, path: path)
            return cardFlow
        }
        catch {
            print("❌ Card Flow Failed", error)
            return nil
        }
        
    }

    func performCreateCardReg(
        cardReg: MGPCardRegistration.Initiate,
        config: Configuration
    ) async -> MGPCardRegistration? {
        do {
            let regResponse = try await PaymentCoreClient(
                env: config.env
            ).createCardRegistrationViaGlitch(
                cardReg,
                backendURl: config.backendURL
            )

            return regResponse
        } catch {
            print("❌ Error Creating Card Registration")
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
