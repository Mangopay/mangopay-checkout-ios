//
//  UIViewController+extensions.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 09/12/2022.
//

import Foundation
import UIKit

@nonobjc extension UIViewController {
  
    internal class func fromNib<T: UIView>() -> T {
        Bundle.main.loadNibNamed(
            String(describing: T.self), owner: nil, options: nil
        )!.first! as! T // swiftlint:disable:this force_cast
    }
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

var topmostViewController: UIViewController? {
    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
    while let controller = rootViewController?.presentedViewController {
        rootViewController = controller
    }
    return rootViewController
}
