//
//  File.swift
//  
//
//  Created by Elikem Savie on 17/10/2022.
//

import Foundation
#if os(iOS)
import UIKit
#endif

import PassKit


public enum BorderType {
    case square
    case round
}

public class PaymentFormStyle {
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var borderType: BorderType = .round
    var textColor: UIColor = .black
    var placeHolderColor: UIColor = .gray
    var borderColor: UIColor = .gray
    var borderFocusedColor: UIColor = .blue
    var errorColor: UIColor = .red
    var checkoutButtonTextColor: UIColor = .white
    var checkoutButtonBackgroundColor: UIColor = .black
    var checkoutButtonDisabledBackgroundColor: UIColor = .gray
    var checkoutButtonText: String = "Pay"
    var checkoutTitleText: String = "Checkout"

    var applePayButtonType: PKPaymentButtonType = .plain
    var applePayButtonStyle: PKPaymentButtonStyle = .black
    var applePayButtonCornerRadius: CGFloat = 8
    
    public init(
        font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
        borderType: BorderType = .round,
        backgroundColor: UIColor = .white,
        textColor: UIColor = .black,
        placeHolderColor: UIColor = .gray,
        borderColor: UIColor = .gray,
        borderFocusedColor: UIColor = .blue,
        errorColor: UIColor = .red,
        checkoutButtonTextColor: UIColor = .white,
        checkoutButtonBackgroundColor: UIColor = .black,
        checkoutButtonDisabledBackgroundColor: UIColor = .gray,
        checkoutButtonText: String = "Pay",
        checkoutTitleText: String = "Checkout",
        applePayButtonType: PKPaymentButtonType = .plain,
        applePayButtonStyle: PKPaymentButtonStyle = .black,
        applePayButtonCornerRadius: CGFloat = 8
    ) {
        self.font = font
        self.borderType = borderType
        self.textColor = textColor
        self.placeHolderColor = placeHolderColor
        self.borderColor = borderColor
        self.borderFocusedColor = borderFocusedColor
        self.errorColor = errorColor
        self.checkoutButtonTextColor = checkoutButtonTextColor
        self.checkoutButtonBackgroundColor = checkoutButtonBackgroundColor
        self.checkoutButtonDisabledBackgroundColor = checkoutButtonDisabledBackgroundColor
        self.checkoutButtonText = checkoutButtonText
        self.checkoutTitleText = checkoutTitleText
        self.applePayButtonType = applePayButtonType
        self.applePayButtonStyle = applePayButtonStyle
        self.applePayButtonCornerRadius = applePayButtonCornerRadius
    }
}
