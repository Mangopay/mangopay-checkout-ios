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
