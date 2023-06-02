//
//  File.swift
//  
//
//  Created by Elikem Savie on 22/02/2023.
//

import Foundation
import MangoPaySdkAPI

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

public class MangoPayVault {
    
    private var paylineClient: CardRegistrationClientProtocol?

    private let clientId: String?
    private let environment: Environment!

    public init(
        clientId: String? = nil,
        provider: Provider = .MANGOPAY,
        environment: Environment
    ) {
        self.clientId = clientId
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
        
        guard let _clientId = clientId else { return }

        if paylineClient == nil {
            paylineClient = CardRegistrationClient(url: environment.url)
        }

        Task {
            do {
                guard let url = _cardRegistration.registrationURL else { return }
                
                guard var _card = card as? CardInfo else { return }

                _card.accessKeyRef = _cardRegistration.accessKey
                _card.data = _cardRegistration.preregistrationData

                let redData = try await self.paylineClient!.postCardInfo(_card, url: url)
                
                guard !redData.RegistrationData.hasPrefix("errorCode") else {
                    let code = String(redData.RegistrationData.split(separator: "=").last ?? "")
                    DispatchQueue.main.async {
                        delegate?.onFailure(
                            error: NSError(
                                domain: "Payline API error: \(redData.RegistrationData)",
                                code: Int(code) ?? 09101,
                                userInfo: ["Error": redData.RegistrationData]
                            )
                        )
                    }
                    return
                }
                guard let cardId = _cardRegistration.id else { return }
                
                let updateRes = try await paylineClient!.updateCardInfo(
                    redData,
                    clientId: _clientId,
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
        
        if !VaultLuhnChecker.luhnCheck(cardNum) {
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

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "MMYY"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"

        guard let actualDate = dateFormatter.date(from: dateStr) else { return false }

//        guard let actualDate = Date(dateStr, format: "MMYY") else { return false }
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
