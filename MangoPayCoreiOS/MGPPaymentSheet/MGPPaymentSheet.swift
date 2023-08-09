//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation
import MangoPaySdkAPI
import UIKit

public struct MGPPaymentSheet {

    static var clientId: String!
    static var environment: MGPEnvironment!

    private static var paymentFormVC: PaymentFormController!
    private var presentingVC: UIViewController!

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
        guard MGPPaymentSheet.paymentFormVC != nil else { return }
        let nav = UINavigationController(rootViewController: MGPPaymentSheet.paymentFormVC)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true)
    }

    public func tearDown() {
        guard presentingVC != nil else { return }
        presentingVC.dismiss(animated: true)
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

}
