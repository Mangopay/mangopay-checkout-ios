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
    let apikey = "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC"
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

        let viewController = ElementCardController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        present(viewController, animated: true)
    }
    
     func didTapDropInCheckout(selectedProduct: Product) {
        let cardConfig = CardConfig(supportedCardBrands: [.visa, .amex])

        let style = PaymentFormStyle(
            font: .systemFont(ofSize: 18),
            textColor: .black,
            placeHolderColor: .gray,
            errorColor: .red
        )
        
        let dropInOptions = DropInOptions(
            apiKey: apikey,
            clientId: "checkoutsquatest",
            orderId: nil,
            style: style,
            customerId: nil,
            flowId: flowID,
            amount: selectedProduct.price,
            currencyCode: "USD",
            countryCode: "US",
            threeDSRedirectURL: "https://documentation.whenthen.com",
            delegate: self
        )

         MangoPaySDK.buildDropInForm(
            with: dropInOptions,
            cardConfig: cardConfig,
            present: self,
            dropInDelegate: self
        )
        
         startIntent(amount: Int(selectedProduct.price))
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

extension ProductListController: DropInFormDelegate {

    func didUpdateBillingInfo(sender: PaymentFormViewModel) {
//        let intentClient = MangoPayIntent(clientKey: apikey)
//        
//        Task {
//            do {
//                let indtentData = try await intentClient.updateIntent(
//                    intentId: intentId,
//                    trackingId: nil,
//                    shipping: MGPShippingDeliveryInput(status: .inProgress))
//                self.intentId = indtentData.id
//                MangoPaySDK.setIntentId(indtentData.id)
////                print("🤣 updateIntent", indtentData)
//            } catch {
//                print("❌❌ Intent Error", error)
//            }
//        }
    }
    
    func onPaymentStarted(sender: PaymentFormViewModel) {
        
    }
    
    func onApplePayCompleteDropIn(status: MangoPayApplePay.PaymentStatus) {
        
    }
    

    func onPaymentCompleted(sender: PaymentFormViewModel, payment: GetPayment) {
        print(" onPaymentCompleted \(payment)")
        self.dismiss(animated: true) {
            self.showAlert(with: payment.id, title: "Payment Successful 🎉🎉🎉")
        }
    }

    func onPaymentFailed(sender: PaymentFormViewModel, error: MangoPayError) {
        print(" onPaymentFailed \(error)")
    }
    
}

extension ProductListController: ElementsFormDelegate {
    func onTokenGenerated(vaultCard: MangoPaySdkAPI.CardRegistration) {
        
    }
    
    func onPaymentStarted(sender: PaymentFormViewModel, payment: GetPayment) {
        
    }
    
    func onApplePayCompleteElement(status: MangoPayApplePay.PaymentStatus) {
        
    }
    

    func onTokenGenerated(tokenizedCard: TokenizeCard) {
        print("Element Token Succesfully Generated \(tokenizedCard.token)")
        self.showAlert(with: tokenizedCard.token, title: "Payment Sucessful 🎉🎉🎉")
    }
    
    func onTokenGenerationFailed(error: Error) {
        print("Element Token Failed")
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
        ac.addAction(UIAlertAction(title: "Elements", style: .default, handler: {_ in
            self.didTapElementCheckout(selectedProduct: prod)
           }))
        ac.addAction(UIAlertAction(title: "Drop In", style: .default, handler: { _ in
            self.didTapDropInCheckout(selectedProduct: prod)
        }))
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
           ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
           present(ac, animated: true)
    }
    
}

extension ProductListController {
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
