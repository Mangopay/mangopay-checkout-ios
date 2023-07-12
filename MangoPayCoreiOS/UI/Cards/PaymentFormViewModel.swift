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
import MangopayVault

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
    func onTokenGenerated(vaultCard: MGPCardRegistration)
    func onTokenGenerationFailed(error: Error)
    func onPaymentStarted(sender: PaymentFormViewModel, payment: GetPayment)
}

public class PaymentFormViewModel {
    
    var formData: CardData?
    var client: MangoPayClient!
    var tokenObserver = PassthroughSubject<TokenizeCard, Never>()
    var statusObserver = PassthroughSubject<String, Never>()
    var trigger3DSObserver = PassthroughSubject<URL, Never>()
    var onComplete: (() -> Void)?

    var dropInData: DropInOptions?

    var mgpClient: MangopayClient
    var callback: CallBack
    

    init(clientId: String, client: MangopayClient, callback: CallBack) {
        self.client = MangoPayClient(clientKey: clientId)
        self.mgpClient = client
        self.callback = callback
    }

    init(
        client: MangopayClient,
        paymentMethodConfig: PaymentMethodConfig,
        callback: CallBack
    ) {
        self.mgpClient = client
        self.callback = callback
        self.client = MangoPayClient(
            clientKey: client.clientId ?? "",
            apiKey: client.apiKey ?? "",
            environment: client.environment
        )
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
//                self.callback.onTokenizationCompleted?(<#MGPCardRegistration#>)
//                self.elementDelegate?.onTokenGenerated(tokenizedCard: tokenizedCard)
            }
        } catch {
            DispatchQueue.main.async {
                print("❌❌ Error tokeninsing Card \(error.localizedDescription)")
                self.callback.onError?(error)
//                self.elementDelegate?.onTokenGenerationFailed(error: error)
            }
        }
    }

    func tokenizeCardElement(with cardReg: MGPCardRegistration) {
        guard let inputData = formData?.toPaymentCardInfo() else { return }
        
        MangoPayVault.initialize(clientId: client.clientKey, environment: .sandbox)

        MangoPayVault.tokenizeCard(
            card: CardInfo(
                cardNumber: inputData.cardNumber,
                cardExpirationDate: inputData.cardExpirationDate,
                cardCvx: inputData.cardCvx,
                cardType: inputData.cardType,
                accessKeyRef: inputData.accessKeyRef,
                data: inputData.data
            ),
            cardRegistration:
                CardRegistration(
                    id: cardReg.id,
                    tag: cardReg.tag,
                    creationDate: cardReg.creationDate,
                    userID: cardReg.userID,
                    accessKey: cardReg.accessKey,
                    preregistrationData: cardReg.preregistrationData,
                    cardID: cardReg.cardID,
                    cardType: cardReg.cardType,
                    cardRegistrationURLStr: cardReg.cardRegistrationURLStr,
                    currency: cardReg.currency,
                    status: cardReg.status
                )

        ) { tokenisedCard, error in
                guard let card = tokenisedCard else {
                    self.callback.onError?(error!)
                    return
                }

                self.callback.onTokenizationCompleted?(
                    MGPCardRegistration(
                        id: card.id,
                        tag: card.tag,
                        creationDate: card.creationDate,
                        userID: card.userID,
                        accessKey: card.accessKey,
                        preregistrationData: card.preregistrationData,
                        cardID: card.cardID,
                        cardType: card.cardType,
                        cardRegistrationURLStr: card.cardRegistrationURLStr,
                        currency: card.currency,
                        status: card.status
                    )
                )
                
                let preAuth = PreAuthCard(
                    authorID: "3401451442",
                    debitedFunds: DebitedFunds(currency: "EUR", amount: 10),
                    secureMode: "FORCE",
                    cardID: card.cardID!,
                    secureModeNeeded: true,
                    secureModeRedirectURL: "https://docs.mangopay.com",
                    secureModeReturnURL: "https://docs.mangopay.com"
                )
                Task {
                    do {
                        let pre = try await self.client.createPreAuth(
                            preAuth: preAuth,
                            clientId: self.client.clientKey,
                            apiKey: self.client.apiKey
                        )
                        
                        if let url = URL(string: pre.secureModeRedirectURL!) {
                            self.onComplete?()
                            self.trigger3DSObserver.send(url)
                        }

                    } catch { error
                        print("❌ createPreAuth", error)
                        self.onComplete?()
                    }

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
//                    self.dropInDelegate?.onPaymentFailed(sender: self, error: .onTokenGenerationFailed(reason: error.localizedDescription))
                    self.callback.onError?(error)

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

        do {
            print("🤣 data.intentId", data.intentId)
            authpayment = try await client.authorizePayment(payment: authData)
            self.statusObserver.send("Succesfully authorised: \(authpayment.id )")
        } catch {
            guard let graphError = error as? GraphQLError else {
                let error = MangoPayError.onAuthorizePaymentFailed(reason: nil)
                self.callback.onError?(error)
                return
            }

            guard let code = graphError.extensions?["code"] as? String,
                  code == "error.authorize.requires3DSecure",
                  let urlStr = graphError.extensions?["url"] as? String
            else {
                self.callback.onError?(MangoPayError.onAuthorizePaymentFailed(reason: nil))
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
//                self.callback.onPaymentCompleted?(<#MGPCardInfo#>)
            }
        } catch {
            DispatchQueue.main.async {
                self.callback.onError?(MangoPayError.onAuthorizePaymentFailed(reason: nil))
                return
            }
        }
    }

    func createCardRegistration() async -> MGPCardRegistration? {
        do {
            let regResponse = try await self.client.createCardRegistration(
                card: MGPCardRegistration.Initiate(
                    UserId: "3401451442",
                    Currency: "EUR",
                    CardType: "CB_VISA_MASTERCARD"
                ),
                clientId: "checkoutsquatest",
                apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC"
            )
            return regResponse
        } catch {
            return nil
        }
    }

    func performDropinPayIn(with inputData: PaymentCardInput?) async {
        guard let inputData = formData?.toPaymentCardInfo() else { return }

        MangoPayVault.initialize(clientId: client.clientKey, environment: .sandbox)

        Task {
            let regResponse = try await self.client.createCardRegistration(
                card: MGPCardRegistration.Initiate(
                    UserId: "3401451442",
                    Currency: "EUR",
                    CardType: "CB_VISA_MASTERCARD"
                ),
                clientId: client.clientKey,
                apiKey: client.apiKey
            )

            MangoPayVault.tokenizeCard(
                card: CardInfo(
                        cardNumber: inputData.cardNumber,
                        cardExpirationDate: inputData.cardExpirationDate,
                        cardCvx: inputData.cardCvx,
                        cardType: inputData.cardType,
                        accessKeyRef: inputData.accessKeyRef,
                        data: inputData.data
                    ),
                cardRegistration: regResponse.toVaultCardReg) { tokenisedCard, error in
                    if let cardValError = error as? CardValidationError {
                        
                    }
                }
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
