import Foundation
import UIKit
import NethoneSDK

public struct MangopayCheckoutSDK {

    static var clientId: String!
    static var environment: MGPEnvironment!

    public static func initialize(clientId: String, environment: MGPEnvironment) {
        self.clientId = clientId
        self.environment = environment
        SentryManager.initialize()
        Tokenizer.initialize(clientId: clientId, environment: environment)
        NTHNethone.setMerchantNumber(Constants.nethoneMerchantId)

        SentryManager.log(name: .SDK_INITIALIZED)
        SentryManager.log(name: .NETHONE_PROFILER_INIT)
    }

    public static func tokenizeCard(
        form: MGPPaymentForm,
        with cardReg: MGPCardRegistration,
        payData: PayInPreAuthProtocol? = nil,
        presentIn viewController: UIViewController? = nil,
        callBack: @escaping MangopayTokenizedCallBack
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
            DispatchQueue.main.async {
                callBack(tokenizedCardData, error)
            }
//            launch3DSIfPossible(payData: _payinData, presentIn: viewController, on3DSSucces: on3DSSucces, on3DSFailure: on3DSFailure)
        }
    }

    public static func launch3DSIfPossible(
        payData: PayInPreAuthProtocol? = nil,
        presentIn viewController: UIViewController?,
        on3DSSucces: ((String) -> ())? = nil,
        on3DSFailure: ((String) -> ())? = nil,
        on3DSError: ((MGPError) -> ())? = nil
    ) {
        guard payData?.secureModeNeeded == true else {
            print("secureModeNeeded is false ")
            return
        }
        
        guard let _ = payData else {
            on3DSError?(MGPError._3dsPayInDataRqd)
            return
        }
        
        guard let _ = viewController else {
            on3DSError?(MGPError._3dsPresentingVCRqd)
            return
        }
        
        guard let urlStr = payData?.secureModeRedirectURL, let url = URL(string: urlStr) else {
            return
        }

        SentryManager.log(name: .THREE_AUTH_REQ)

        let _3dsVC = ThreeDSController(
            secureModeReturnURL: url,
            secureModeRedirectURL: nil,
            transactionType: .cardDirect,
            onComplete: { result in
                switch result.status {
                case .SUCCEEDED:
                    on3DSSucces?(result.id)
                    SentryManager.log(name: .THREE_AUTH_COMPLETED)
                case .FAILED:
                    on3DSFailure?(result.id)
                    SentryManager.log(name: .THREE_AUTH_FAILED)
                }
            }) { error in
                on3DSError?(MGPError._3dsError(additionalInfo: error?.localizedDescription))
                SentryManager.log(name: .THREE_AUTH_FAILED)
            }
        
        viewController?.present(_3dsVC, animated: true)
    }
}
