//
//  File.swift
//  
//
//  Created by Elikem Savie on 01/08/2023.
//

import Foundation
import UIKit

public class MGPPaymentSheet {

    private static var paymentFormVC: PaymentFormController!
    private var presentingVC: UIViewController!
    private var navVC: UINavigationController!

    public init() {
        self.presentingVC = nil
        navVC = UINavigationController(rootViewController: MGPPaymentSheet.paymentFormVC)
        navVC.restorationIdentifier = "elikem"
        navVC.modalPresentationStyle = .fullScreen

    }

    public static func create(
        paymentMethodConfig: PaymentMethodOptions,
        handlePaymentFlow: Bool = false,
        branding: PaymentFormStyle,
        supportedCardBrands: [CardType]? = nil,
        callback: CallBack
    ) -> MGPPaymentSheet {
        paymentFormVC = PaymentFormController(
            paymentMethodConfig: paymentMethodConfig,
            handlePaymentFlow: handlePaymentFlow,
            branding: branding,
            supportedCardBrands: supportedCardBrands,
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
        navVC.setNavigationBarHidden(true, animated: false)
        viewController.present(navVC, animated: true)
    }

    public func tearDown(completion: (() -> Void)? = nil) {
        guard presentingVC != nil else { return }
        navVC.dismiss(animated: true, completion: completion)
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

    public func pushViewController(_ viewController: UIViewController) {
        self.navVC.pushViewController(viewController, animated: true)
    }
    

    public func launch3DSIfPossible(
        payData: Payable? = nil,
        presentIn viewController: UIViewController?,
        on3DSSucces: ((_3DSResult) -> ())? = nil,
        on3DSLauch: ((UIViewController) -> ())? = nil,
        on3DSFailure: ((String) -> ())? = nil,
        on3DSError: ((MGPError) -> ())? = nil
    ) {
        
        self.presentingVC = viewController
        
        guard payData?.secureModeNeeded == true else {
            print("secureModeNeeded is false ")
            on3DSError?(MGPError._3dsNotRqd)
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
                
        let _3dsVC = ThreeDSController(
            secureModeReturnURL: url,
            secureModeRedirectURL: nil,
            transactionType: .cardDirect,
            onComplete: { result in
                switch result.status {
                case .SUCCEEDED:
                    on3DSSucces?(result)
                case .FAILED, .CANCELLED:
                    on3DSFailure?(result.id)
                }
            }) { error in
                on3DSError?(MGPError._3dsError(additionalInfo: error?.localizedDescription))
            }
        
        on3DSLauch?(_3dsVC)
        
    }

}
