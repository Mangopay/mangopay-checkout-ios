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

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupObservers()
    }

    public override func loadView() {
        view = formView
    }

//    static func present(on viewController: UIViewController) {
//        viewController.present(self, animated: true)
//    }

    func setupObservers() {
        formView.viewModel.tokenObserver.sink { tokenised in
            self.showAlert(with: tokenised.token, title: "Tokenised Card")
        }.store(in: &cancelables)
        
        Task {
            let items = try await WhenThenClient.shared.fetchCards(with: nil)
            print("🇬🇭 ", items.map({$0.brand }))
            
//            self.formView.setCards(cards: items.compactMap({$0.brandType}))
            for item in items {
                print(item)
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

