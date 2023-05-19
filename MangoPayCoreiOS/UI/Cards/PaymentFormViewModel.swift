//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/10/2022.
//

import Foundation
import Combine
import ApolloAPI
import Apollo
import MangoPaySdkAPI

public protocol DropInFormDelegate: AnyObject {
    func onPaymentStarted(sender: PaymentFormViewModel)
    func onPaymentCompleted(sender: PaymentFormViewModel, payment: GetPayment)
    func onPaymentFailed(sender: PaymentFormViewModel, error: MangoPayError)
    func onApplePayCompleteDropIn(status: MangoPayApplePay.PaymentStatus)
    func didUpdateBillingInfo(sender: PaymentFormViewModel)
}

public protocol ElementsFormDelegate: AnyObject {
    func onPaymentStarted(sender: PaymentFormViewModel)
    func onTokenGenerated(tokenizedCard: TokenizeCard)
    func onTokenGenerationFailed(error: Error)
    func onApplePayCompleteElement(status: MangoPayApplePay.PaymentStatus)
    func onPaymentStarted(sender: PaymentFormViewModel, payment: GetPayment)
}

public class PaymentFormViewModel {
    
    var formData: CardData?
    var client: MangoPayClient!
    var tokenObserver = PassthroughSubject<TokenizeCard, Never>()
    var statusObserver = PassthroughSubject<String, Never>()
    var trigger3DSObserver = PassthroughSubject<URL, Never>()

    weak var dropInDelegate: DropInFormDelegate?
    weak var elementDelegate: ElementsFormDelegate?

    var dropInData: DropInOptions?

    init(clientId: String) {
        self.client = MangoPayClient(clientKey: clientId)
    }

    func fetchCards() {
//        client.fetchCards(with: nil)
    }

    func tokenizeCard() async {
        guard let inputData = formData?.toPaymentCardInput() else { return }

        do {
            let tokenizedCard = try await client.tokenizeCard(with: inputData, customer: nil)
    
            DispatchQueue.main.async {
                self.tokenObserver.send(tokenizedCard)
                self.elementDelegate?.onTokenGenerated(tokenizedCard: tokenizedCard)
            }
        } catch {
            DispatchQueue.main.async {
                print("❌❌ Error tokeninsing Card \(error.localizedDescription)")
                self.elementDelegate?.onTokenGenerationFailed(error: error)
            }
        }
    }

    func performDropin(with inputData: PaymentCardInput?, cardToken: String?) async {
        
        var tokenizedCard: TokenizeCard?
        var authpayment: AuthorizePaymentResponse!
        
        if let _data = inputData {
            do {
                tokenizedCard = try await client.tokenizeCard(with: _data, customer: nil)
                self.statusObserver.send("Succesfully tokenized: \(tokenizedCard!.token )")
            } catch {
                DispatchQueue.main.async {
                    print("❌❌ Error tokeninsing Card \(error.localizedDescription)")
                    self.dropInDelegate?.onPaymentFailed(sender: self, error: .onTokenGenerationFailed(reason: error.localizedDescription))
                    return
                }
            }
        }

        let token = tokenizedCard != nil ? tokenizedCard?.token : cardToken
    
        guard let token = token else {
            print("❌ token is nil")
            return
        }

        guard let data = dropInData else { return }
        
        let authData = AuthorisedPayment(
            orderId: data.orderId,
            flowId: data.flowId,
            intentId: data.intentId,
            amount: String(data.amount),
            currencyCode: data.currencyCode,
            paymentMethod: PaymentDtoInput(
                type: .card,
                token: token
            ),
            perform3DSecure: AuthorisedPayment._3DSecure(redirectUrl: data.threeDSRedirectURL)
        )

//        let payIndata = AuthorizePayIn(
//            authorID: "AUTHOR_ID",
//            debitedFunds: DebitedFunds(
//                currency: data.currencyCode,
//                amount: Int(data.amount)
//            )
//        )

        do {
            print("🤣 data.intentId", data.intentId)
            authpayment = try await client.authorizePayment(payment: authData)
            self.statusObserver.send("Succesfully authorised: \(authpayment.id )")
        } catch {
            guard let graphError = error as? GraphQLError else {
                let error = MangoPayError.onAuthorizePaymentFailed(reason: nil)
                dropInDelegate?.onPaymentFailed(sender: self, error: error)
                return
            }

            guard let code = graphError.extensions?["code"] as? String,
                  code == "error.authorize.requires3DSecure",
                  let urlStr = graphError.extensions?["url"] as? String
            else {
                self.dropInDelegate?.onPaymentFailed(
                    sender: self,
                    error: .onAuthorizePaymentFailed(reason: nil)
                )
                return
            }
            
            if let url = URL(string: urlStr) {
                trigger3DSObserver.send(url)
            }

            return
        }

        do {
            let getPayment = try await client.getPayment(with: authpayment.id)
            self.statusObserver.send("Succesfully Retrieved payment: \(getPayment.id )")
            DispatchQueue.main.async {
                self.dropInDelegate?.onPaymentCompleted(sender: self, payment: getPayment)
            }
        } catch {
            DispatchQueue.main.async {
                self.dropInDelegate?.onPaymentFailed(
                    sender: self,
                    error: .onAuthorizePaymentFailed(reason: error.localizedDescription)
                )
                return
            }
        }
    }

    func authorizePayment(authPayment: AuthorisedPayment) async {
        
        do {
            let authorizedPayment = try await client.authorizePayment(payment: authPayment)
            
            print("✅ authorizedPayment", authorizedPayment)
            
            DispatchQueue.main.async {
//                self.tokenObserver.send(authorizedPay)
            }
        } catch {
            print("❌❌ Error authorizing Payment  \(error.localizedDescription)")
        }
    }

    func createCustomer(with customerInput: CustomerInputData) async {
        do {
            let tokenizedCard = try await client.createCustomer(with: customerInput)
            DispatchQueue.main.async {
                print("DONEEE ")
                print(" 🤣 tokenizedCard", tokenizedCard)
            }
        } catch {
            print("❌❌ Error createCustomer Card \(error.localizedDescription)")
        }
    }

    func getPayment(with id: String) async -> GetPayment? {
        do {
            let paymentData = try await client.getPayment(with: id)
            return paymentData
        } catch {
            print("❌❌ Error Getting payment \(error.localizedDescription)")
            return nil
        }
    }

    func fetchCards(customerId: String) async -> [ListCustomerCard]  {
        do {
            let cards = try await client.fetchCards(with: customerId)
            return cards
        } catch {
            print("❌❌ Error Fetching Cards \(error.localizedDescription)")
            return [ListCustomerCard]()
        }
    }

}
//4000002760003184
