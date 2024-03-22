//
//  ViewController+Extensions.swift
//  
//
//  Created by Elikem Savie on 18/12/2023.
//

import UIKit

var topmostViewController: UIViewController? {
    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
    while let controller = rootViewController?.presentedViewController {
        rootViewController = controller
    }
    return rootViewController
}

extension UIViewController {
    func showAlert(with cardToken: String, title: String) {
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
