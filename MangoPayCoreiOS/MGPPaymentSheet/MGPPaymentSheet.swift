//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation
import MangoPaySdkAPI
import UIKit

public class MGPPaymentSheet {

    static var clientId: String!
    static var environment: MGPEnvironment!

    private static var paymentFormVC: PaymentFormController!
    private var presentingVC: UIViewController!
    private var navVC: UINavigationController!

    public init() {
        self.presentingVC = nil
//        self.navVC = nil
        navVC = UINavigationController(rootViewController: MGPPaymentSheet.paymentFormVC)
        navVC.modalPresentationStyle = .fullScreen

    }

    public static func initialize(clientId: String, environment: MGPEnvironment) {
        self.clientId = clientId
        self.environment = environment
        Tokenizer.initialize(clientId: clientId, environment: environment)
    }

    public static func create(
        client: MangopayClient,
        paymentMethodConfig: PaymentMethodConfig,
        handlePaymentFlow: Bool,
        branding: PaymentFormStyle,
        callback: CallBack
    ) -> MGPPaymentSheet {
        paymentFormVC = PaymentFormController(
            client: client,
            paymentMethodConfig: paymentMethodConfig,
            handlePaymentFlow: handlePaymentFlow,
            branding: branding,
            callback: callback
        )
        let mgp = MGPPaymentSheet()
        return mgp
    }

    public func present(in viewController: UIViewController) {
        self.presentingVC = viewController
        guard MGPPaymentSheet.paymentFormVC != nil else { return }
        navVC = UINavigationController(rootViewController: MGPPaymentSheet.paymentFormVC)
        navVC.modalPresentationStyle = .fullScreen
        viewController.present(navVC, animated: true)
    }

    public func tearDown() {
        guard presentingVC != nil else { return }
//        presentingVC.dismiss(animated: true)
        navVC.dismiss(animated: true)
    }

    public func isPaymentFormValid() -> Bool {
        return MGPPaymentSheet.paymentFormVC.isFormValid()
    }

    public func clearForm() {
        MGPPaymentSheet.paymentFormVC.clearForm()
    }

    public func validate() {
        MGPPaymentSheet.paymentFormVC.manuallyValidateForms()
    }

    public func launch3DSIfPossible(
        payData: PayInPreAuthProtocol? = nil,
        presentIn viewController: UIViewController?,
        on3DSSucces: ((String) -> ())? = nil,
        on3DSLauch: ((UIViewController) -> ())? = nil,
        on3DSFailure: ((MGPError) -> ())? = nil
    ) {
        
        self.presentingVC = viewController
        
        guard payData?.secureModeNeeded == true else {
            print("😅 secureModeNeeded is false ")
            on3DSFailure?(MGPError._3dsNotRqd)
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
        
        on3DSLauch?(_3dsVC)
        
    }

}
