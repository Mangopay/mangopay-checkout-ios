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
    
    //paymentComplete
    //payment failed
    
    //paymentSuccess
    //paymentFailed
    //
}

public protocol ElementsFormDelegate: AnyObject {
    func onTokenGenerated(tokenisedCard: TokeniseCard)
    func onTokenGenerationFailed(error: Error)
}

public class PaymentFormViewModel {
    
    var formData: FormData?
    var client: WhenThenClient!
    var tokenObserver = PassthroughSubject<TokeniseCard, Never>()
    var statusObserver = PassthroughSubject<String, Never>()

    weak var dropInDelegate: DropInFormDelegate?
    weak var elementDelegate: ElementsFormDelegate?

    var dropInData: DropInOptions?

    init(clientId: String) {
        self.client = WhenThenClient(clientKey: clientId)
    }

    func fetchCards() {
//        client.fetchCards(with: nil)
    }

    func tokeniseCard() async {
        guard let inputData = formData?.toPaymentCardInput() else { return }

        do {
            let tokenisedCard = try await client.tokenizeCard(with: inputData)
    
            DispatchQueue.main.async {
                self.tokenObserver.send(tokenisedCard)
                self.elementDelegate?.onTokenGenerated(tokenisedCard: tokenisedCard)
            }
        } catch {
            DispatchQueue.main.async {
                print("❌❌ Error tokeninsing Card \(error.localizedDescription)")
                self.elementDelegate?.onTokenGenerationFailed(error: error)
            }
        }
    }

    func performDropin(with inputData: PaymentCardInput?, cardToken: String?) async {
        
        var tokenisedCard: TokeniseCard?
        var authpayment: AuthorizePaymentResponse!
        
        if let _data = inputData {
            do {
                tokenisedCard = try await client.tokenizeCard(with: _data)
                self.statusObserver.send("Succesfully Tokenised: \(tokenisedCard!.token )")
                dropInDelegate?.onTokenGenerated(sender: self, tokenisedCard: tokenisedCard!)
            } catch {
                DispatchQueue.main.async {
                    print("❌❌ Error tokeninsing Card \(error.localizedDescription)")
                    self.dropInDelegate?.onTokenGenerationFailed(sender: self, error: error)
                    return
                }
            }
        }

        let token = tokenisedCard != nil ? tokenisedCard?.token : cardToken
    
        guard let token = token else {
            print("❌ token is nil")
            return
        }

        guard let data = dropInData else { return }
        
        let authData = AuthorisedPayment(
            orderId: data.orderId,
            flowId: data.flowId,
            amount: String(data.amount),
            currencyCode: data.currencyCode,
            paymentMethod: PaymentDtoInput(
                type: .card,
                token: token
            ),
            perform3DSecure: AuthorisedPayment._3DSecure(redirectUrl: "http://localhost:3000")
        )

        do {
            authpayment = try await client.authorizePayment(payment: authData)
            self.statusObserver.send("Succesfully authorised: \(authpayment.id )")
            dropInDelegate?.onAuthorizePaymentSuccess(sender: self, response: authpayment)
        } catch {
            print("❌❌ Error authorising \(error.localizedDescription)")
            dropInDelegate?.onAuthorizePaymentFailed(sender: self, error: error)
            return
        }

        do {
            let getPayment = try await client.getPayment(with: authpayment.id)
            self.statusObserver.send("Succesfully Retrieved payment: \(getPayment.id )")
            dropInDelegate?.onPaymentCompleted(sender: self, payment: getPayment)
        } catch {
            DispatchQueue.main.async {
                print("❌❌ Error GetPayment \(error.localizedDescription)")
                self.dropInDelegate?.onPaymentFailed(sender:  self, error: error)
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
//4000002760003184
