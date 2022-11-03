//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/10/2022.
//

import Foundation
import Combine
import SchemaPackage
import ApolloAPI
import Apollo

public protocol DropInFormDelegate: AnyObject {
    func onTokenGenerated(sender: PaymentFormViewModel, tokenisedCard: TokeniseCard)
    func onTokenGenerationFailed(sender: PaymentFormViewModel, error: Error)
    func onAuthorizePaymentSuccess(sender: PaymentFormViewModel, response: AuthorizePaymentResponse)
    func onAuthorizePaymentFailed(sender: PaymentFormViewModel, error: Error)
    func onPaymentCompleted(sender: PaymentFormViewModel, payment: GetPayment)
    func onPaymentFailed(sender: PaymentFormViewModel, error: Error)
}

public class PaymentFormViewModel {
    
    var formData: FormData?
    let client = WhenThenClient()
    var tokenObserver = PassthroughSubject<TokeniseCard, Never>()
    var statusObserver = PassthroughSubject<String, Never>()

    weak var delegate: DropInFormDelegate?

    init() {
        
    }

    func fetchCards() {
//        client.fetchCards(with: nil)
    }

    func tokeniseCard() async {
        guard let inputData = formData?.toPaymentCardInput() else { return }

        do {
            let tokenisedCard = try await client.tokenizeCard(with: inputData)

            let authData = AuthorisedPayment(
                orderId: "5114e019-9316-4498-a16d-4343fda403eb",
                flowId: "b4869810-04e3-4ae9-98b6-6d6de57d9e85",
                amount: "500",
                currencyCode: "EUR",
                paymentMethod: PaymentDtoInput(
                    type: "CARD",
                    token: tokenisedCard.token
                )
            )

            let authpayment = try await client.authorizePayment(payment: authData)
            let getPayment = try await client.getPayment(with: authpayment.id)
    
            DispatchQueue.main.async {
                self.tokenObserver.send(tokenisedCard)
            }
        } catch {
            print("❌❌ Error tokeninsing Card \(error.localizedDescription)")
        }
    }

    func performDropin(with inputData: PaymentCardInput?, cardToken: String?) async {
        
        var tokenisedCard: TokeniseCard?
        var authpayment: AuthorizePaymentResponse!
        
        if let _data = inputData {
            do {
                tokenisedCard = try await client.tokenizeCard(with: _data)
                self.statusObserver.send("Succesfully Tokenised: \(tokenisedCard!.token )")
                delegate?.onTokenGenerated(sender: self, tokenisedCard: tokenisedCard!)
            } catch {
                print("❌❌ Error tokeninsing Card \(error.localizedDescription)")
                delegate?.onTokenGenerationFailed(sender: self, error: error)
                return
            }
        }

        let token = tokenisedCard != nil ? tokenisedCard?.token : cardToken
    
        guard let token = token else {
            print("❌ token is nil")
            return
        }
        
        let authData = AuthorisedPayment(
            orderId: "5114e019-9316-4498-a16d-4343fda403eb",
            flowId: "b4869810-04e3-4ae9-98b6-6d6de57d9e85",
            amount: "500",
            currencyCode: "EUR",
            paymentMethod: PaymentDtoInput(
                type: "CARD",
                token: token
            )
        )
            

        do {
            authpayment = try await client.authorizePayment(payment: authData)
            self.statusObserver.send("Succesfully authorised: \(authpayment.id )")
            delegate?.onAuthorizePaymentSuccess(sender: self, response: authpayment)
        } catch {
            print("❌❌ Error authorising \(error.localizedDescription)")
            delegate?.onAuthorizePaymentFailed(sender: self, error: error)
            return
        }

        do {
            let getPayment = try await client.getPayment(with: authpayment.id)
            self.statusObserver.send("Succesfully Retrieved payment: \(getPayment.id )")
            delegate?.onPaymentCompleted(sender: self, payment: getPayment)
        } catch {
            print("❌❌ Error GetPayment \(error.localizedDescription)")
            delegate?.onPaymentFailed(sender: self, error: error)
            return
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
            let tokenisedCard = try await client.createCustomer(with: customerInput)
            DispatchQueue.main.async {
                print("DONEEE ")
                print(" 🤣 tokenisedCard", tokenisedCard)
            }
        } catch {
            print("❌❌ Error createCustomer Card \(error.localizedDescription)")
        }
    }

    func getPayment(with id: String) async {
        do {
            let paymentData = try await client.getPayment(with: id)
            DispatchQueue.main.async {
                print("DONEEE ")
                print(" 🤣 paymentData", paymentData)
            }
        } catch {
            print("❌❌ Error Getting payment \(error.localizedDescription)")
        }
    }

}
