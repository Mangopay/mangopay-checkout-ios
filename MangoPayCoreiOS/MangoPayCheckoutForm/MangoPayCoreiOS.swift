import MGPPegasusAPI
import Foundation
import UIKit

public struct MGPPegasus {

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
        on3DSFailure: (() -> ())? = nil
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
            print("😅 main func tokenizedCardData", tokenizedCardData)
            print("😅 static func", error)
            callBack(tokenizedCardData, error)
            launch3DSIfPossible(payData: payData, presentIn: viewController, on3DSSucces: on3DSSucces, on3DSFailure: on3DSFailure)
        }
    }

    private static func launch3DSIfPossible(
        payData: PayInPreAuthProtocol? = nil,
        presentIn viewController: UIViewController?,
        on3DSSucces: ((String) -> ())? = nil,
        on3DSFailure: (() -> ())? = nil
    ) {
        guard payData?.secureModeNeeded == true else {
            print("😅 secureModeNeeded is false ")
            return
        }

        guard let _payData = payData else {
//            callBack(nil, NSError(domain: "PayIN data neeeded", code: 1022))
            return
        }

        guard let _vc = viewController else {
//            callBack(nil, NSError(domain: "PayIN data neeeded", code: 1022))
            return
        }

        guard let url = payData?.secureModeRedirectURL else { return }

        let _3dsVC = ThreeDSController(
            successUrl: url,
            failUrl: url
        )

        _3dsVC.onSuccess = { paymentId in
            on3DSSucces?(paymentId)
        }

        _3dsVC.onFailure = {
            on3DSFailure?()
        }

        viewController?.present(_3dsVC, animated: true)
    }
}
