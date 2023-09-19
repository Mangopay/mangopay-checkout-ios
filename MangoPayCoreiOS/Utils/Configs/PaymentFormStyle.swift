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

public enum BorderType {
    case square
    case round
}

public class PaymentFormStyle {
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var borderType: BorderType = .round
//    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var placeHolderColor: UIColor = .gray
    var borderColor: UIColor = .gray
    var borderFocusedColor: UIColor = .blue
    var errorColor: UIColor = .red
    var checkoutButtonTextColor: UIColor = .white
    var checkoutButtonBackgroundColor: UIColor = .black
    var checkoutButtonDisabledBackgroundColor: UIColor = .gray

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
        checkoutButtonDisabledBackgroundColor: UIColor = .gray
    ) {
        self.font = font
        self.borderType = borderType
//        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.placeHolderColor = placeHolderColor
        self.borderColor = borderColor
        self.borderFocusedColor = borderFocusedColor
        self.errorColor = errorColor
        self.checkoutButtonTextColor = checkoutButtonTextColor
        self.checkoutButtonBackgroundColor = checkoutButtonBackgroundColor
        self.checkoutButtonDisabledBackgroundColor = checkoutButtonDisabledBackgroundColor
    }
}


//public class CheckoutTheme {
//    /// Background color of the views
//    public  var primaryBackgroundColor: UIColor = UIColor.groupTableViewBackground
//    public  var secondaryBackgroundColor: UIColor = .white
//    /// Background used for the Table View Cell in country selection table
//    public  var tertiaryBackgroundColor: UIColor = .white
//    /// Main text color
//    public  var color: UIColor = .black
//    /// Secondary text color
//    public  var secondaryColor: UIColor = .lightGray
//    /// Error text color
//    public  var errorColor: UIColor = .red
//    /// Chevron color
//    public  var chevronColor: UIColor = .black
//    /// Font
//    public  var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//    /// Bar style, used for the search bar
//    public  var barStyle: UIBarStyle = UIBarStyle.default
//}
