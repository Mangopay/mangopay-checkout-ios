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
import MangoPayVault

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
    func onTokenGenerated(vaultCard: CardRegistration)
    func onTokenGenerationFailed(error: Error)
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

    init(clientId: String, apiKey: String, environment: Environment) {
        self.client = MangoPayClient(clientKey: clientId, apiKey: apiKey, environment: environment)
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

    func tokenizeCardElement(with cardReg: CardRegistration) {
        guard let inputData = formData?.toPaymentCardInfo() else { return }
        
        let mgpVault = MangoPayVault(
            clientId: client.clientKey,
            provider: .MANGOPAY,
            environment: client.environment
        )
        
        mgpVault.tokenizeCard(
            card: inputData,
            cardRegistration: cardReg,
            delegate: self
        )
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

    func performDropinPayIn(with inputData: PaymentCardInput?) async {
        guard let inputData = formData?.toPaymentCardInfo() else { return }

        Task {
            let regResponse = try await client.createCardRegistration(
                card: CardRegistration.Initiate(
                    UserId: "158091557",
                    Currency: "EUR",
                    CardType: "CB_VISA_MASTERCARD"
                ),
                clientId: client.clientKey,
                apiKey: client.apiKey
            )

            let mgpVault = MangoPayVault(
                clientId: client.clientKey,
                provider: .MANGOPAY,
                environment: client.environment
            )
    
            mgpVault.tokenizeCard(
                card: inputData,
                cardRegistration: regResponse,
                delegate: self
            )
        }
    }

    func getPayInAuth3DSStatus(preAuthId: String) async -> PreAuthCard? {
        do {
            
            let preAuthStatus = try await client.viewPreAuth(
                preAuthId: preAuthId,
                clientId: client.clientKey,
                apiKey: client.clientKey
            )
            return preAuthStatus
        } catch {
            print("❌❌ Error getting getPayInAuth3DSStatus  \(error.localizedDescription)")
            return nil
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

extension PaymentFormViewModel: MangoPayVaultDelegate {
    public func onSuccess(card: CardRegistration) {
        self.elementDelegate?.onTokenGenerated(vaultCard: card)
        
        let preAuth = PreAuthCard(
            authorID: "158091557",
            debitedFunds: DebitedFunds(currency: "EUR", amount: 10),
            secureMode: "FORCE",
            cardID: card.cardID!,
            secureModeNeeded: true,
            secureModeRedirectURL: "https://docs.mangopay.com",
            secureModeReturnURL: "https://docs.mangopay.com"
        )
        Task {
            do {
                let pre = try await client.createPreAuth(
                    preAuth: preAuth,
                    clientId: client.clientKey,
                    apiKey: client.apiKey
                )
                
                if let url = URL(string: pre.secureModeRedirectURL!) {
                    trigger3DSObserver.send(url)
                }

            } catch { error
                print("❌ createPreAuth", error)
            }

        }
    }

    public func onFailure(error: Error) {
        self.elementDelegate?.onTokenGenerationFailed(error: error)
    }
    
    
}
