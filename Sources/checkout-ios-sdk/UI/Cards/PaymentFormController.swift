//
//  PaymentFormController.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import UIKit
import Combine

public class PaymentFormController: UIViewController {

    lazy var formView = PaymentFormView()
    var cancelables = Set<AnyCancellable>()
    var cardConfig: CardConfig?

    public init(cardConfig: CardConfig? = nil, paymentDelegate: DropInFormDelegate) {
        super.init(nibName: nil, bundle: nil)
        formView.viewModel.delegate = paymentDelegate
        self.cardConfig = cardConfig
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        formView.setCards(cards: self.cardConfig)
    }

    public override func loadView() {
        view = formView
    }

    func setupObservers() {
        formView.viewModel.tokenObserver.sink { tokenised in
            self.showAlert(with: tokenised.token, title: "Tokenised Card")
        }.store(in: &cancelables)

        formView.viewModel.statusObserver.sink { status in
            DispatchQueue.main.async {
                let text = self.formView.statusLabel.text ?? ""
                self.formView.statusLabel.text = text.appending("\n \n \(status) \n ==========")
            }
        }.store(in: &cancelables)

        Task {
            let items = try await WhenThenClient.shared.fetchCards(with: nil)
            
            let cards = items.compactMap({$0.brandType})
            self.formView.setUsersCards(cards)
            
            formView.onRightButtonTappedAction = {
                CustomerCardListController.showDatePicker(with: self, cardLists: items) { cardType in
                    self.formView.cardNumberField.text = cardType.number
                }
            }

        }

    }
    
    private func showAlert(with cardToken: String, title: String) {
        let alert = UIAlertController(
            title: title,
            message: cardToken,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

