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
