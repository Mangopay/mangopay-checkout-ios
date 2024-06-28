//
//  File.swift
//  
//
//  Created by Elikem Savie on 23/11/2023.
//

import Foundation
import UIKit

protocol AlertDisplayer {
    func displayAlert(
        with title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [UIAlertAction]?
    )
}

extension AlertDisplayer where Self: UIViewController {
    func displayAlert(
        with title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [UIAlertAction]? = [UIAlertAction(title: "OK", style: .default)]
    ) {
        guard presentedViewController == nil else {
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}

extension UIViewController: AlertDisplayer {

    func displayAlert(title: String, message: String, actions: [UIAlertAction]?) {
        displayAlert(
            with: title,
            message: message,
            preferredStyle: .alert,
            actions: actions
        )
    }

}
