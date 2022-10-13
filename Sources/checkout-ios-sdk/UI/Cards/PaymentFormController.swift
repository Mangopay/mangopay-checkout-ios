//
//  PaymentFormController.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import UIKit

public class PaymentFormController: UIViewController {

    lazy var formView = PaymentFormView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    public override func loadView() {
        view = formView
    }

//    static func present(on viewController: UIViewController) {
//        viewController.present(self, animated: true)
//    }
}

