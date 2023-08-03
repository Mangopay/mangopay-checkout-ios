//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation
import MGPPegasusAPI

public class PaymentFormViewModel {

    var mgpClient: MangopayClient
//    var callback: CallBack
    
    var selectedPaymentMethod: PaymentMethod = .card(.none)

    init(
        client: MangopayClient,
        paymentMethodConfig: PaymentMethodConfig
//        callback: CallBack
    ) {
        self.mgpClient = client
//        self.callback = callback
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
            }

            if let _error = error {
                callback.onError?(_error)
            }
        }
    }
}
