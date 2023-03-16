//
//  File.swift
//  
//
//  Created by Elikem Savie on 22/02/2023.
//

import Foundation
import MangoPaySdkAPI
import MangoPayCoreiOS

public protocol MangoPayVaultDelegate: AnyObject {
    func onSuccess(card: CardRegistration)
    func onFailure(error: Error)
}

public protocol MangoPayVaultWTTokenisationDelegate: AnyObject {
    func onSuccess(tokenisedCard: TokeniseCard)
    func onFailure(error: Error)
}

public protocol MangoPayVaultCreateCustomerDelegate: AnyObject {
    func onCustomerCreatedSuccessfully(customerId: String)
    func onCustomerCreationFailed(error: Error)
}

public protocol MangoPayVaultPaymentMethodsDelegate: AnyObject {
    func onSucessfullyFetchPaymentMethods(paymentMthods: [GetPaymentMethod])
    func onFetchPaymentMethodsFailure(error: Error)
}

public enum Provider: String {
    case WHENTHEN
    case MANGOPAY
}

public class MangoPayVault {
    
    private let client = CardRegistrationClient()
    private let cardData: Cardable?
    let provider: Provider
    private let clientToken: String

    public init(
        clientToken: String,
        provider: Provider,
        cardData: Cardable?
    ) {
        self.cardData = cardData
        self.clientToken = clientToken
        self.provider = provider
    }

    public func tokeniseWT(
        cardPayment: CardData,
        delegate: MangoPayVaultWTTokenisationDelegate
    ) {
        
        guard provider == .WHENTHEN else {
            return
        }

        Task {
            let client = WhenThenClient(clientKey: clientToken)
            
            do {
                let isValidCard = try validateCard(with: cardPayment)
                
                guard isValidCard else { return }
                
                let tokenisedCard = try await client.tokenizeCard(with: cardPayment.toPaymentCardInput())
                delegate.onSuccess(tokenisedCard: tokenisedCard)
            } catch {
                delegate.onFailure(error: error)
            }
        }
        
    }

    public func tokeniseMGP(
        with cardInfo: CardInfo,
        cardRegistration: CardRegistration,
        delegate: MangoPayVaultDelegate
    ) {
        
        guard provider == .MANGOPAY else {
            return
        }

        Task {
            do {
                let isValidCard = try validateCard(with: cardInfo)
                
                guard isValidCard else { return }
                guard let url = cardRegistration.registrationURL else { return }

                let redData = try await client.postCardInfo(cardInfo, url: url)
                
                guard let cardId = cardRegistration.id else { return }
                
                let updateRes = try await client.updateCardInfo(
                    redData,
                    clientId: self.clientToken,
                    cardRegistrationId: cardId
                )
                
                DispatchQueue.main.async {
                    delegate.onSuccess(card: updateRes)
                }
                
            } catch {
                DispatchQueue.main.async {
                    delegate.onFailure(error: error)
                }
            }
        }
        
    }

    public func createCustomer(
        _ customer: Customer,
        delegate: MangoPayVaultCreateCustomerDelegate
    ) {
        guard provider == .WHENTHEN else {
            return
        }

        Task {
            do {
                let customerRes = try await WhenThenClient(
                    clientKey: clientToken
                ).createCustomer(
                    with: CustomerInputData(customer: customer)
                )
                DispatchQueue.main.async {
                    delegate.onCustomerCreatedSuccessfully(customerId: customerRes)
                }
            } catch {
                DispatchQueue.main.async {
                    delegate.onCustomerCreationFailed(error: error)
                }
            }
        }
    }

    public func getPaymentMethods(
        customerId: String,
        clientToken: String,
        delegate: MangoPayVaultPaymentMethodsDelegate
    ) {
        guard provider == .WHENTHEN else {
            return
        }

        Task {
            let client = WhenThenClient(clientKey: clientToken)
    
            do {
                let resPaymentMethods = try await client.getPaymentMethodsForCustomer(customerId)
                let paymentMethods = resPaymentMethods.compactMap({$0})
                DispatchQueue.main.async {
                    delegate.onSucessfullyFetchPaymentMethods(paymentMthods: paymentMethods)
                }
            } catch {
                DispatchQueue.main.async {
                    delegate.onFetchPaymentMethodsFailure(error: error)
                }
            }
        }
    }
    
    private func validateCard(with cardInfo: Cardable) throws -> Bool {
        
        guard let cardNum = cardInfo.cardNumber else {
            throw CardValidationError.cardNumberRqd
        }
        
        guard let expirationDate = cardInfo.cardExpirationDate else {
            throw CardValidationError.expDateRqd
        }
        
        guard let cvv = cardInfo.cvc else {
            throw CardValidationError.cvvRqd
        }
        
        if !LuhnChecker.luhnCheck(cardNum) {
            throw CardValidationError.cardNumberInvalid
        }
        
        if !expDateValidation(dateStr: expirationDate) {
            throw CardValidationError.expDateInvalid
        }
        
        if !(cvv.count >= 3 || cvv.count <= 4) {
            throw CardValidationError.cvvInvalid
        }
        
        return true
    }
}

extension MangoPayVault {
    
    func expDateValidation(dateStr: String) -> Bool {

        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        guard let actualDate = Date(dateStr, format: "MMYY") else { return false }
        let enteredYear = Calendar.current.dateComponents([.year], from: actualDate).year ?? 0
        let enteredMonth = Calendar.current.dateComponents([.month], from: actualDate).month ?? 0

        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                return true
            } else {
                return false
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }

    }
}
