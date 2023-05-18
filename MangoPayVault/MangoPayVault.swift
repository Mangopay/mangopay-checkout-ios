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

public protocol MangoPayVaultCreateCustomerDelegate: AnyObject {
    func onCustomerCreatedSuccessfully(customerId: String)
    func onCustomerCreationFailed(error: Error)
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
//            return URL(string: "https://testing3-api.mangopay.com")!
            return URL(string: "https://api.sandbox.mangopay.com")!
        case .prod:
            return URL(string: "https://api.mangopay.com")!
        }
    }
}

public class MangoPayVault {
    
    private var paylineClient: CardRegistrationClientProtocol?

    private let clientToken: String?
    private let environment: Environment!

    public init(
        clientToken: String? = nil,
        provider: Provider = .MANGOPAY,
        environment: Environment
    ) {
        self.clientToken = clientToken
        self.environment = environment
    }

    func setPaylineClient(paylineClient: CardRegistrationClientProtocol) {
        self.paylineClient = paylineClient
    }

    public func tokenizeCard(
        card: Cardable,
        cardRegistration: CardRegistration? = nil,
        delegate: MangoPayVaultDelegate? = nil
    ) {
        do {
            let isValidCard = try validateCard(with: card)
            guard isValidCard else { return }
            guard let _cardRegistration = cardRegistration else { return }
            
            tokenizeMGP(
                with: card,
                cardRegistration: _cardRegistration,
                delegate: delegate
            )
        } catch {
            DispatchQueue.main.async {
                delegate?.onFailure(error: error)
            }
        }
        
    }

    private func tokenizeMGP(
        with card: Cardable,
        cardRegistration: CardRegistration?,
        delegate: MangoPayVaultDelegate? = nil
    ) {

        guard let _cardRegistration = cardRegistration else { return }
        
        guard let _clientToken = clientToken else { return }

        if paylineClient == nil {
            paylineClient = CardRegistrationClient(url: environment.url)
        }

        Task {
            do {
                guard let url = _cardRegistration.registrationURL else { return }
                
                guard var _card = card as? CardInfo else { return }

                _card.accessKeyRef = _cardRegistration.accessKey
                _card.data = _cardRegistration.preregistrationData

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
