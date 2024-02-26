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

        form.setCardRegistration(cardRegistration)
        form.tokenizeCard { tokenizedCardData, error in
            if let _ = tokenizedCardData, let card = tokenizedCardData?.card, let cardData = tokenizedCardData {
                
                NethoneManager.shared.performFinalizeAttempt { _ in
                    DispatchQueue.main.async {
                        callback.onTokenizationCompleted?(cardData)
                        self.onTokenisationCompleted?()
                    }
                }
            }

            if let _error = error {
                DispatchQueue.main.async {
                    self.onTokenisationError?(_error)
                    callback.onError?(_error)
                }
            }
        }
    }
}
