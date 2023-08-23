import MangoPaySdkAPI
import Foundation
import UIKit

public struct MangoPayCoreiOS {

    static var clientId: String!
    static var environment: MGPEnvironment!

    public static func initialize(clientId: String, environment: MGPEnvironment) {
        self.clientId = clientId
        self.environment = environment
        Tokenizer.initialize(clientId: clientId, environment: environment)
    }

    public static func tokenizeCard(
        form: MangoPayCheckoutForm,
        with cardReg: MGPCardRegistration,
        payData: PayInPreAuthProtocol? = nil,
        presentIn viewController: UIViewController? = nil,
        callBack: @escaping MangoPayTokenizedCallBack,
        on3DSSucces: ((String) -> ())? = nil,
        on3DSFailure: ((MGPError) -> ())? = nil
    ) {

//        guard clientId != nil, !clientId.isEmpty else {
//            callBack(nil, MGPError.initializationRqd)
//            return
//        }

        guard form.isFormValid else {
            callBack(nil, MGPError.invalidForm)
            return
        }
        guard let attemptRef = form.currentAttempt else {
            callBack(nil, MGPError.nethoneAttemptReferenceRqd)
            return
        }

        Tokenizer.tokenize(
            card: form.cardData,
            with: cardReg.toVaultCardReg,
            nethoeAttemptedRef: attemptRef
        ) { tokenizedCardData, error in
            var _payinData = payData
            _payinData?.cardID = tokenizedCardData?.card.cardID
            callBack(tokenizedCardData, error)
//            launch3DSIfPossible(payData: _payinData, presentIn: viewController, on3DSSucces: on3DSSucces, on3DSFailure: on3DSFailure)
        }
    }

    public static func launch3DSIfPossible(
        payData: PayInPreAuthProtocol? = nil,
        presentIn viewController: UIViewController?,
        on3DSSucces: ((String) -> ())? = nil,
        on3DSFailure: ((MGPError) -> ())? = nil
    ) {
        guard payData?.secureModeNeeded == true else {
            print("😅 secureModeNeeded is false ")
            return
        }

        guard let _payData = payData else { 
            on3DSFailure?(MGPError._3dsPayInDataRqd)
            return
        }

        guard let _vc = viewController else {
            on3DSFailure?(MGPError._3dsPresentingVCRqd)
            return
        }

        guard let urlStr = payData?.secureModeRedirectURL, let url = URL(string: urlStr) else {
            return
        }
        
//        guard let payIn = payData as? PreAuthCard else { return }
        
//        Task {
//            do {
//                let pre = try await PaymentCoreClient(env: .sandbox).createPreAuth(
//                    clientId: clientId,
//                    apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC",
//                    preAuth: payIn
//                )

//                guard let secureModeReturnURL = URL(string: pre.secureModeReturnURL!) else {
//                    return
//                }
                print("😅 url", url)
        
        

                let _3dsVC = ThreeDSController(
                    secureModeReturnURL: url,
                    secureModeRedirectURL: nil,
                    onSuccess: { paymentId in
                        on3DSSucces?(paymentId)
                    },
                    onFailure: { error in
                        on3DSFailure?(MGPError._3dsError(additionalInfo: error?.localizedDescription))
                    }
                )
                
                 viewController?.present(_3dsVC, animated: true)
                
//            } catch { error
//                print("❌ createPreAuth", error)
//            }
            
//        }
    

    }
}
