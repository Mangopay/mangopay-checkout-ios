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

public class MangoPayVault {
    
    private let client = CardRegistrationClient()


    public init() { }
    
    public func tokenisePaymentMethod(
        clientId: String,
        with cardInfo: CardInfo,
        cardRegistration: CardRegistration,
        delegate: MangoPayVaultDelegate
    ) {
        Task {
            do {
                let isValidCard = try validateCard(with: cardInfo)
                
                guard isValidCard else { return }
                guard let url = cardRegistration.registrationURL else { return }

                let redData = try await client.postCardInfo(cardInfo, url: url)
                
                guard let cardId = cardRegistration.id else { return }
                
                let updateRes = try await client.updateCardInfo(
                    redData,
                    clientId: clientId,
                    cardRegistrationId: cardId
                )
                
                delegate.onSuccess(card: updateRes)
            } catch {
                delegate.onFailure(error: error)
            }
        }
        
    }
    
    private func validateCard(with cardInfo: CardInfo) throws -> Bool {
        
        guard let cardNum = cardInfo.cardNumber else {
            throw CardValidationError.cardNumberRqd
        }
        
        guard let expirationDate = cardInfo.cardExpirationDate else {
            throw CardValidationError.expDateRqd
        }
        
        guard let cvv = cardInfo.cardCvx else {
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
