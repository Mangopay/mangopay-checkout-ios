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

public enum Environment: String {
    case sandbox
    case prod

    public var url: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://testing3-api.mangopay.com")!
        case .prod:
            return URL(string: "https://api.mangopay.com")!
        }
    }
}

public class MangoPayVault {
    
    private var paylineClient: CardRegistrationClientProtocol?
    private var wtClient: WhenThenClientSessionProtocol?

    let provider: Provider
    private let clientToken: String?
    private let clientId: String?
    private let cardRegistration: CardRegistration?
    private let environment: Environment!

    public init(
        clientToken: String? = nil,
        clientId: String? = nil,
        cardRegistration: CardRegistration? = nil,
        provider: Provider = .MANGOPAY,
        environment: Environment
    ) {
        self.clientToken = clientToken
        self.clientId = clientId
        self.provider = provider
        self.cardRegistration = cardRegistration
        self.environment = environment
    }

    func setWtClient(wtClient: WhenThenClientSessionProtocol) {
        self.wtClient = wtClient
    }

    func setPaylineClient(paylineClient: CardRegistrationClientProtocol) {
        self.paylineClient = paylineClient
    }

    public func tokeniseCard(
        card: Cardable,
        paylineDelegate: MangoPayVaultDelegate? = nil,
        whenThenDelegate: MangoPayVaultWTTokenisationDelegate? = nil
    ) {
        do {
            let isValidCard = try validateCard(with: card)
            guard isValidCard else { return }
            guard let _cardRegistration = cardRegistration else { return }
            switch provider {
            case .WHENTHEN:
                tokeniseWT(card: card, delegate: whenThenDelegate)
            case .MANGOPAY:
                tokeniseMGP(
                    with: card,
                    cardRegistration: _cardRegistration,
                    delegate: paylineDelegate
                )
            }
        } catch {
            switch provider {
            case .WHENTHEN:
                DispatchQueue.main.async {
                    whenThenDelegate?.onFailure(error: error)
                }
            case .MANGOPAY:
                DispatchQueue.main.async {
                    paylineDelegate?.onFailure(error: error)
                }
            }
        }
        
    }

    private func tokeniseWT(
        card: Cardable,
        delegate: MangoPayVaultWTTokenisationDelegate?
    ) {
        
        guard provider == .WHENTHEN else {
            return
        }

        guard let _card = card as? CardData else { return }

        guard let _clientId = clientId else { return }

        Task {
            if wtClient == nil {
                wtClient = WhenThenClient(clientKey: _clientId)
            }
            
            do {
                let tokenisedCard = try await wtClient!.tokenizeCard(
                    with: _card.toPaymentCardInput(), customer: nil
                )
                DispatchQueue.main.async {
                    delegate?.onSuccess(tokenisedCard: tokenisedCard)
                }
            } catch {
                DispatchQueue.main.async {
                    delegate?.onFailure(error: error)
                }
            }
        }
        
    }

    private func tokeniseMGP(
        with card: Cardable,
        cardRegistration: CardRegistration?,
        delegate: MangoPayVaultDelegate? = nil
    ) {

        guard provider == .MANGOPAY else {
            return
        }
    
        guard let _card = card as? CardInfo else { return }
        
        guard let _cardRegistration = cardRegistration else { return }
        
        guard let _clientToken = clientToken else { return }

        if paylineClient == nil {
            paylineClient = CardRegistrationClient(url: environment.url)
        }

        Task {
            do {
                guard let url = _cardRegistration.registrationURL else { return }

                let redData = try await paylineClient!.postCardInfo(_card, url: url)
                
                guard let cardId = _cardRegistration.id else { return }
                
                let updateRes = try await paylineClient!.updateCardInfo(
                    redData,
                    clientId: _clientToken,
                    cardRegistrationId: cardId
                )
                
                DispatchQueue.main.async {
                    delegate?.onSuccess(card: updateRes)
                }
            } catch {
                DispatchQueue.main.async {
                    delegate?.onFailure(error: error)
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

        guard let _clientId = clientId else { return }

        Task {
            do {
                let customerRes = try await WhenThenClient(
                    clientKey: _clientId
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

        guard let _clientId = clientId else { return }

        Task {
            let client = WhenThenClient(clientKey: _clientId)
    
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
    
    func validateCard(with cardInfo: Cardable) throws -> Bool {
        
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
        
        if !(cvv.count >= 3 && cvv.count <= 4) {
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
