//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/10/2022.
//

import Foundation
import Apollo
import ApolloAPI
import SchemaPackage

class Client {

    private(set) lazy var apollo: ApolloClient = {
        let apiEndpoint = "https://api.sandbox.whenthen.co/api/graphql"
        return ApolloClient(url: URL(string: apiEndpoint)!)
    }()

    func fetchCards(with customerId: String?) {
        let _customerId = customerId ?? "a4a7cb68-9ce6-4874-84df-276d7e9b235b"
        let query = ListCustomerCardsQuery(vaultCustomerId: _customerId)
        
        apollo.fetch(query: query) { result in
            print("✅ Fetching Cards ..")
            guard let data = try? result.get().data else {
                print("❌ Failed to fetch Cards ..")
                return
            }
            print(data.listCustomerCards)
        }
    }

    func tokenizeCard(with card: ListCustomerCardsQuery.Data.ListCustomerCard) {

        let _vCard = PaymentCardInput(
            number: card.number,
            expMonth: card.expMonth,
            expYear: card.expYear
        )

        let y = GraphQLNullable<SchemaPackage.PaymentCardInput>(_vCard)

        let paymentMethodInput = SchemaPackage.PaymentMethodInput(card: y)

        let tokenInput = TokenInput(
            paymentMethod: paymentMethodInput
        )

        let mutation = TokeniseCardMutation(data: tokenInput)
        apollo.perform(mutation: mutation) { result in
            
            switch result {
            case .success(let reponse):
                print("🤣 tokenizeCard ", reponse.data)
            case .failure(let error):
                print("❌ Failed to tokenizeCard ..")            }
        }
    }

    func authorizePayment(card: ListCustomerCardsQuery.Data.ListCustomerCard) {

        let _vCard = PaymentCardInput(
            number: card.number,
            expMonth: card.expMonth,
            expYear: card.expYear
        )
        let y = GraphQLNullable<SchemaPackage.PaymentCardInput>(_vCard)
//        let paymentMethodInput = SchemaPackage.PaymentMethodInput(card: y)

        let inputData = AuthorisedPaymentInput(
            orderId: "5114e019-9316-4498-a16d-4343fda403eb",
            flowId: "b4869810-04e3-4ae9-98b6-6d6de57d9e85",
            currencyCode: "EUR",
            amount: "200",
            paymentMethod: PaymentMethodDtoInput(
                type: "CARD",
                token: "wqvnlUkYZDaXzpeC"
            )
        )

        let mutation = AuthorizePaymentMutation(authorisePayment: inputData)
        apollo.perform(mutation: mutation)  { result in
            switch result {
            case .success(let reponse):
                print("🤣 authorizedCard", reponse.data)
            case .failure(let error):
                print("❌ Failed to authorizePayment ..")            }
        }

    }
}
