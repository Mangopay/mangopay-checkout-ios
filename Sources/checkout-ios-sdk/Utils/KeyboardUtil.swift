//
//  File.swift
//  
//
//  Created by Elikem Savie on 16/10/2022.
//

import UIKit
import Foundation

protocol KeyboardUtilDelegate: class {
    func keyboardDidShow(sender: KeyboardUtil, rect: CGRect, animationDuration: Double)
    func keyboardDidHide(sender: KeyboardUtil, animationDuration: Double)
}

final class KeyboardUtil {

    var original: CGFloat = 0
    var padding: CGFloat = 0
    var keyboardRect: CGRect = .zero
    weak var delegate: KeyboardUtilDelegate?

    init(original: CGFloat = 0, padding: CGFloat = 0) {
        self.original = original
        self.padding = padding
    }

    func register() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func unregister() {
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] else {
            return
        }

        self.delegate?.keyboardDidShow(
            sender: self, rect: keyboardSize.cgRectValue,
            animationDuration: (durationValue as? NSNumber)?.doubleValue ?? 0.3
        )
    }

    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] else {
                return
        }

        self.delegate?.keyboardDidHide(
            sender: self,
            animationDuration: (durationValue as? NSNumber)?.doubleValue ?? 0.3
        )
    }

}
