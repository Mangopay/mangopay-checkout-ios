//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation
import MangoPaySdkAPI

public class PaymentFormViewModel {

    var mgpClient: MangopayClient
    var onTokenisationCompleted: (() -> Void)?
    var onTokenisationError: ((MGPError) -> ())?

    var selectedPaymentMethod: PaymentMethod = .card(.none)

    init(
        client: MangopayClient,
        paymentMethodConfig: PaymentMethodConfig
    ) {
        self.mgpClient = client
    }
    
    func tokenizeCard(
        form: MangoPayCheckoutForm,
        cardRegistration: MGPCardRegistration?,
        callback: CallBack
    ) {

        form.setCardRegistration(cardRegistration)
        form.tokenizeCard { tokenizedCardData, error in
            if let _tokenized = tokenizedCardData, let card = tokenizedCardData?.card {
                callback.onTokenizationCompleted?(card.toMGPCardReg)
                self.onTokenisationCompleted?()
            }

            if let _error = error {
                self.onTokenisationError?(_error)
                callback.onError?(_error)
            }
        }
    }
}
