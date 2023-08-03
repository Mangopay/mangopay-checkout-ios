//
//  PaymentFormController.swift
//  
//
//  Created by Elikem Savie on 31/07/2023.
//

import UIKit
import MGPPegasusAPI

class PaymentFormController: UIViewController {

    var formView: PaymentFormView!

    var client: MangopayClient
    var paymentFormStyle: PaymentFormStyle
    var callback: CallBack
    var paymentMethodConfig: PaymentMethodConfig
    var handlePaymentFlow: Bool

    public init(
        cardConfig: CardConfig? = nil,
        client: MangopayClient,
        paymentMethodConfig: PaymentMethodConfig,
        handlePaymentFlow: Bool,
        branding: PaymentFormStyle?,
        callback: CallBack
    ) {

        self.paymentFormStyle = branding ?? PaymentFormStyle()
        self.callback = callback
        self.client = client
        self.paymentMethodConfig = paymentMethodConfig
        self.handlePaymentFlow = handlePaymentFlow

        formView = PaymentFormView(
            client: client,
            paymentMethodConfig: paymentMethodConfig,
            handlePaymentFlow: handlePaymentFlow,
            branding: branding,
            callback: callback
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = formView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        formView.onClosedTapped = {
            self.dismiss(animated: true) {
                self.callback.onSheetDismissed?()
            }
        }
    }

    func setNavigation() {
        title = "Checkout"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }

    @objc func closeTapped() {
        dismiss(animated: true) {
            self.callback.onSheetDismissed?()
        }
    }

    func clearForm() {
        formView.clearForm()
    }

    func isFormValid() -> Bool {
        return formView.isFormValid
    }

    func manuallyValidateForms() {
        formView.manuallyValidateForms()
    }
}
