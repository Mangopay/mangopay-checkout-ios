import Foundation
import UIKit
import NethoneSDK

public struct MangopayCheckoutSDK {

    static var clientId: String!
    public static var apiKey: String!
    static var environment: MGPEnvironment!

    public static func initialize(
        clientId: String,
        profillingMerchantId: String,
        checkoutReference: String,
        environment: MGPEnvironment
    ) {
        self.clientId = clientId
        self.environment = environment

        SentryManager.initialize(
            environment: environment,
            clientId: clientId,
            checkoutReference: checkoutReference,
            profillingMerchantId: profillingMerchantId
        )

        Tokenizer.initialize(
            clientId: clientId,
            checkoutReference: checkoutReference,
            environment: environment
        )

        SentryManager.log(name: .SDK_INITIALIZED)
        SentryManager.log(name: .NETHONE_PROFILER_INIT)
        SentryManager.log(
            error: NSError(
                domain: "tnt",
                code: 10,
                userInfo: [
                    "error": "Test Sentry"
                ]
            )
        )
        NethoneManager.shared.initialize(with: profillingMerchantId)
    }

    public static func tokenizeCard(
        form: MGPPaymentForm,
        with cardReg: MGPCardRegistration,
        payData: Payable? = nil,
        presentIn viewController: UIViewController? = nil,
        callBack: @escaping MangopayTokenizedCallBack
    ) {


        guard form.isFormValid else {
            callBack(nil, MGPError.invalidForm)
            SentryManager.log(error: MGPError.invalidForm)
            return
        }

        guard let attemptRef = NTHNethone.attemptReference() else {
            callBack(nil, MGPError.nethoneAttemptReferenceRqd)
            SentryManager.log(error: MGPError.nethoneAttemptReferenceRqd)
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
        }
    }

    public static func launch3DSIfPossible(
        payData: Payable? = nil,
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
            SentryManager.log(error: MGPError._3dsPayInDataRqd)
            return
        }
        
        guard let _ = viewController else {
            on3DSError?(MGPError._3dsPresentingVCRqd)
            SentryManager.log(error: MGPError._3dsPresentingVCRqd)
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
                default: break
                }
            }) { error in
                on3DSError?(MGPError._3dsError(additionalInfo: error?.localizedDescription))
                SentryManager.log(name: .THREE_AUTH_FAILED)
                if let _error = error {
                    SentryManager.log(error: _error)
                }
            }
        
        viewController?.present(_3dsVC, animated: true)
    }
}
