//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation

public class PaymentFormViewModel {

    var mgpClient: MangopayClient
    var onTokenisationCompleted: (() -> Void)?
    var onCreatePaymentComplete: ((Payable?) -> Void)?
    var onTokenisationError: ((MGPError) -> ())?

    var selectedPaymentMethod: PaymentMethod = .card(.none)

    init(
        client: MangopayClient,
        paymentMethodConfig: PaymentMethodOptions
    ) {
        self.mgpClient = client
    }
    
    func tokenizeCard(
        form: MGPPaymentForm,
        cardRegistration: MGPCardRegistration?,
        callback: CallBack
    ) {
        SentryManager.log(name: .CARD_REGISTRATION_STARTED)
        form.setCardRegistration(cardRegistration)
        form.tokenizeCard { tokenizedCardData, error in
            if let _ = tokenizedCardData, let _ = tokenizedCardData?.card, let cardData = tokenizedCardData {
                
                NethoneManager.shared.performFinalizeAttempt { _ , attemptRef in
                    DispatchQueue.main.async {
                        callback.onTokenizationCompleted?(cardData)
                        self.onTokenisationCompleted?()
                        if let createAction = callback.onCreatePayment {
                            Task {
                                if let paymentObj = await createAction(.card(nil), attemptRef) {
                                    self.onCreatePaymentComplete?(paymentObj)
                                    SentryManager.log(name: .CARD_REGISTRATION_COMPLETED)
                                } else {
                                    SentryManager.log(name: .CARD_REGISTRATION_FAILED)
                                }
                            }
                        }
                    }
                }
            }

            if let _error = error {
                DispatchQueue.main.async {
                    self.onTokenisationError?(_error)
                    callback.onError?(_error)
                    SentryManager.log(error: _error)
                }
            }
        }
    }
}