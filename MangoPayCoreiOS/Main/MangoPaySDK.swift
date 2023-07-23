//
//  File.swift
//  
//
//  Created by Elikem Savie on 09/11/2022.
//

import Foundation
import Apollo
import ApolloAPI
import MangoPaySdkAPI
import MangopayVault

#if os(iOS)
import UIKit
#endif


public struct ElementsOptions {
    var apiKey: String
    var clientId: String
    var style: PaymentFormStyle?
    var environment: MGPEnvironment
    var customerId: String?
    var amount: Float
    var countryCode: String
    var currencyCode: String
    var applePayMerchantId: String?
    var delegate: ElementsFormDelegate
    
    var amountString: String {
        let priceString = String(format: "\(currencyCode) %.02f", amount)
        return priceString
    }
    
    public init(
        apiKey: String,
        clientId: String,
        style: PaymentFormStyle? = nil,
        customerId: String? = nil,
        amount: Float,
        countryCode: String,
        currencyCode: String,
        applePayMerchantId: String? = nil,
        delegate: ElementsFormDelegate
    ) {
        self.apiKey = apiKey
        self.clientId = clientId
        self.style = style
        self.customerId = customerId
        self.delegate = delegate
        self.amount = amount
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.applePayMerchantId = applePayMerchantId
        self.environment = .sandbox

    }
}

public class DropInOptions {
    var apiKey: String
    var clientId: String
    var orderId: String?
    var style: PaymentFormStyle?
    var environment: MGPEnvironment
    var customerId: String?
    var flowId: String
    var amount: Float
    var countryCode: String
    var currencyCode: String
    var applePayMerchantId: String?
    var threeDSRedirectURL: String?
    var intentId: String?
    var delegate: DropInFormDelegate

    var amountString: String {
        let priceString = String(format: "\(currencyCode) %.02f", amount)
        return priceString
    }

    public init(
        apiKey: String,
        clientId: String,
        orderId: String? = nil,
        style: PaymentFormStyle? = nil,
        customerId: String? = nil,
        flowId: String,
        amount: Float,
        currencyCode: String,
        countryCode: String,
        applePayMerchantId: String? = nil,
        threeDSRedirectURL: String? = nil,
        intentId: String? = nil,
        delegate: DropInFormDelegate
    ) {
        self.apiKey = apiKey
        self.clientId = clientId
        self.orderId = orderId
        self.style = style
        self.customerId = customerId
        self.flowId = flowId
        self.amount = amount
        self.currencyCode = currencyCode
        self.countryCode = countryCode
        self.delegate = delegate
        self.intentId = intentId
        self.environment = .sandbox
        self.applePayMerchantId = applePayMerchantId
        self.threeDSRedirectURL = threeDSRedirectURL
    }
}

public class MangoPaySDK {
    
    static var apiKey: String!
    static var clientId: String!
    static var environment: Environment!

    private static var paymentFormVC: PaymentFormController!
    private var presentingVC: UIViewController!
    
    public static func buildElementForm(
        with options: ElementsOptions,
        cardConfig: CardConfig?,
        present viewController: UIViewController
    ) {
//        MangoPaySDK.apiKey = options.apiKey
//        MangoPaySDK.clientId = options.clientId
//        paymentFormVC = PaymentFormController(
//            cardConfig: cardConfig,
//            elementOptions: options
//        )
//        let nav = UINavigationController(rootViewController: paymentFormVC)
//        nav.modalPresentationStyle = .fullScreen
//        viewController.present(nav, animated: true)
    }

    public static func buildDropInForm(
        with options: DropInOptions,
        cardConfig: CardConfig?,
        present viewController: UIViewController,
        dropInDelegate: DropInFormDelegate
    ) {
//        MangoPaySDK.apiKey = options.apiKey
//        MangoPaySDK.clientId = options.clientId
//        paymentFormVC = PaymentFormController(
//            cardConfig: cardConfig,
//            dropInOptions: options
//        )
//        let nav = UINavigationController(rootViewController: paymentFormVC)
//        nav.modalPresentationStyle = .fullScreen
//        viewController.present(nav, animated: true)
    }

    public static func tokeniseCard(apikey: String, card: PaymentCardInput) async throws -> TokenizeCard {

        let client = MangoPayClient(clientKey: apikey)
        do {
            let tokenizedCard = try await client.tokenizeCard(with: card, customer: nil)
            return tokenizedCard
        } catch {
            throw error
        }
    }

    public static func authorizePayment(apikey: String, paymentData: AuthorisedPayment) async throws -> AuthorizePaymentResponse {

        let client = MangoPayClient(clientKey: apikey)
        do {
            let authorizedPayment = try await client.authorizePayment(payment: paymentData)
            return authorizedPayment
        } catch {
            throw error
        }
    }

    public static func createCustomer(apiKey: String, customer: CustomerInputData) async throws -> String {
        
        let client = MangoPayClient(clientKey: apiKey)

        do {
            let customerId = try await client.createCustomer(with: customer)
            return customerId
        } catch {
            throw error
        }
    }

}

extension MangoPaySDK {

    public func isPaymentFormValid() -> Bool {
        return MangoPaySDK.paymentFormVC.isFormValid()
    }

    public func clearForm() {
        MangoPaySDK.paymentFormVC.clearForm()
    }

    public func validate() {
        MangoPaySDK.paymentFormVC.manuallyValidateForms()
    }

    public func tearDown() {
        guard presentingVC != nil else { return }
        presentingVC.dismiss(animated: true)
    }

    public func present(in viewController: UIViewController) {
        guard MangoPaySDK.paymentFormVC != nil else { return }
        let nav = UINavigationController(rootViewController: MangoPaySDK.paymentFormVC)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true)
    }
}

extension MangoPaySDK {
    public static func initialize(clientId: String, environment: Environment) {
        self.clientId = clientId
        self.environment = environment
    }

    public static func tokenizeCard(
        form: MangoPayCheckoutForm,
        with cardReg: CardRegistration,
        payData: PayInPreAuthProtocol? = nil,
        present3DS viewController: UIViewController? = nil,
        callBack: @escaping MangoPayTokenizedCallBack
    ) {
        
        guard form.isFormValid else { return }
        guard let attemptRef = form.currentAttempt else { return }
        
        MangoPayVault.initialize(clientId: clientId, environment: .sandbox)

        Task {
            await MangoPayVault.tokenizeCard(
                card: CardInfo(
                    cardNumber: form.cardData.cardNumber,
                    cardExpirationDate: form.cardData.cardExpirationDate,
                    cardCvx: form.cardData.cardCvx,
                    cardType: form.cardData.cardType,
                    accessKeyRef: form.cardData.accessKeyRef,
                    data: form.cardData.data
                ),
                cardRegistration: cardReg) { tokenisedCard, error in
                    guard let _card = tokenisedCard else {
                        callBack(.none, error)
                        return
                        
                    }
                    let res = TokenizedCardData(
                        card: _card,
                        fraud: FraudData(attemptReference: attemptRef)
                    )
                    callBack(res, .none)
                }
        
            guard let payData = payData, payData.secureModeNeeded == true else { return }
            
        }
    }

}

extension MangoPaySDK {
    public static func create(
        client: MangopayClient,
        paymentMethodConfig: PaymentMethodConfig,
        handlePaymentFlow: Bool,
        branding: PaymentFormStyle,
        callback: CallBack
    ) -> MangoPaySDK {
        paymentFormVC = PaymentFormController(
            client: client,
            paymentMethodConfig: paymentMethodConfig,
            handlePaymentFlow: handlePaymentFlow,
            branding: branding,
            callback: callback
        )
        let mgp = MangoPaySDK()
        return mgp
    }
}


extension MangoPaySDK {

    public static func setIntentId(_ intentId: String) {
        paymentFormVC.formView.dropInOptions?.intentId = intentId
    }
}
