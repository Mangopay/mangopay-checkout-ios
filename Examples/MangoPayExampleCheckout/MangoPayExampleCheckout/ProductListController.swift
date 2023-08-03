//
//  ProductListController.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 09/12/2022.
//

import UIKit
import MangoPayCoreiOS
import MangoPaySdkAPI
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
        Product(name: "COD MW2", price: 69.00,imageName: "codmw2"),
        Product(name: "COD MW", price: 69.00,imageName: "codmw"),
        Product(name: "The Witcher", price: 69.00,imageName: "witcher"),
        Product(name: "Spiderman", price: 69.00,imageName: "spiderman"),
        Product(name: "God Of War", price: 69.00,imageName: "god"),
        Product(name: "God Of War2", price: 69.00,imageName: "god2"),
        Product(name: "Uncharted", price: 69.00,imageName: "uncharted"),
        Product(name: "GTA 5", price: 59, imageName: "gta5"),
    ]

    var selectedProduct: Product?
    var config: DataCapsule!

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
        present(viewController, animated: true)

    }
    
     func didTapDropInCheckout(selectedProduct: Product) {

//         startIntent(amount: Int(selectedProduct.price))
         
         let mgpClient = MangopayClient(
            clientId: config.config.clientId,
             apiKey: config.config.apiKey,
             environment: .sandbox
         )

         let checkout = MGPPaymentSheet.create(
             client: mgpClient,
             paymentMethodConfig: PaymentMethodConfig(
                 cardReg: config.cardReg
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

