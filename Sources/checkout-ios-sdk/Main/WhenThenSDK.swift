//
//  File.swift
//  
//
//  Created by Elikem Savie on 09/11/2022.
//

import Foundation
import UIKit
import Apollo
import ApolloAPI

public enum Ennvironment {
    case sandbox
    case production
}

public struct ElementsOptions {
    var apiKey: String
    var style: PaymentFormStyle?
    var environment: Ennvironment
    var customerId: String?
    var delegate: ElementsFormDelegate
    //billing
    //cvv
    
    public init(
        apiKey: String,
        style: PaymentFormStyle? = nil,
        environment: Ennvironment,
        customerId: String? = nil,
        delegate: ElementsFormDelegate
    ) {
        self.apiKey = apiKey
        self.style = style
        self.environment = environment
        self.customerId = customerId
        self.delegate = delegate
    }
}

public struct DropInOptions {
    var apiKey: String
    var orderId: String?
    var style: PaymentFormStyle?
    var environment: Ennvironment
    var customerId: String?
    var flowId: String
    var amount: Float
    var currencyCode: String
    var delegate: DropInFormDelegate

    public init(
        apiKey: String,
        orderId: String? = nil,
        style: PaymentFormStyle? = nil,
        environment: Ennvironment,
        customerId: String? = nil,
        flowId: String,
        amount: Float,
        currencyCode: String,
        delegate: DropInFormDelegate
    ) {
        self.apiKey = apiKey
        self.orderId = orderId
        self.style = style
        self.environment = environment
        self.customerId = customerId
        self.flowId = flowId
        self.amount = amount
        self.currencyCode = currencyCode
        self.delegate = delegate
    }
}

public struct WhenThenSDK {
    
    static var clientID: String!
    
    public static func buildElementForm(
        with options: ElementsOptions,
        cardConfig: CardConfig?,
        present viewController: UIViewController
    ) {
        WhenThenSDK.clientID = options.apiKey
        let vc = PaymentFormController(
            cardConfig: cardConfig,
            elementOptions: options
        )
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true)
    }

    public static func buildDropInForm(
        with options: DropInOptions,
        cardConfig: CardConfig?,
        present viewController: UIViewController,
        dropInDelegate: DropInFormDelegate
    ) {
        WhenThenSDK.clientID = options.apiKey
        let vc = PaymentFormController(
            cardConfig: cardConfig,
            dropInOptions: options
        )
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true)
    }

    public static func tokeniseCard(apikey: String, card: CheckoutSchema.PaymentCardInput) async throws -> TokeniseCard {

        let client = WhenThenClient(clientKey: apikey)
        do {
            let tokenisedCard = try await client.tokenizeCard(with: card)
            return tokenisedCard
        } catch {
            throw error
        }
    }

    public static func authorizePayment(apikey: String, paymentData: AuthorisedPayment) async throws -> AuthorizePaymentResponse {

        let client = WhenThenClient(clientKey: apikey)
        do {
            let authorizedPayment = try await client.authorizePayment(payment: paymentData)
            return authorizedPayment
        } catch {
            throw error
        }
    }

    public static func createCustomer(apiKey: String, customer: CustomerInputData) async throws -> String {
        
        let client = WhenThenClient(clientKey: apiKey)

        do {
            let customerId = try await client.createCustomer(with: customer)
            return customerId
        } catch {
            throw error
        }
    }


}
