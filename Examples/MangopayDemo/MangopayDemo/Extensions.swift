//
//  Extensions.swift
//  MangopayDemo
//
//  Created by Elikem Savie on 15/11/2023.
//

import Foundation
import UIKit
import CFAlertViewController

public extension UIView {
    // Load Views from Nib
    internal class func fromNib<T: UIView>() -> T {
        Bundle.main.loadNibNamed(
            String(describing: T.self), owner: nil, options: nil
        )!.first! as! T // swiftlint:disable:this force_cast
    }
}

extension UIViewController {
    
    func showSuccessDialog(title: String = "Payment Succesful", result: String) {
        let alertController = CFAlertViewController(
            title: nil,
            message: "",
            textAlignment: .left,
            preferredStyle: .actionSheet,
            didDismissAlertHandler: nil
        )
        
        let congratsView = CongratsView.fromNib() as CongratsView
        
        congratsView.renderLabel(title: title, result: result)
        congratsView.buttonAction = {
            alertController.dismissAlert(withAnimation: true, completion: nil)
        }
        
        alertController.headerView = congratsView
        
        
        present(alertController, animated: true, completion: nil)
    }
    
}
