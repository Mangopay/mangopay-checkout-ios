//
//  File.swift
//  
//
//  Created by Elikem Savie on 17/10/2022.
//

import Foundation
import UIKit

enum BorderType {
    case square
    case round
    case bottom
}

public class PaymentFormStyle {
    static var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    static var borderType: BorderType = .round
    static var backgroundColor: UIColor = .white
    static var textColor: UIColor = .black
    static var placeHolderColor: UIColor = .gray
    static var borderColor: UIColor = .gray
    static var borderFocusedColor: UIColor = .blue
    static var errorColor: UIColor = .red
}


//public class CheckoutTheme {
//    /// Background color of the views
//    public static var primaryBackgroundColor: UIColor = UIColor.groupTableViewBackground
//    public static var secondaryBackgroundColor: UIColor = .white
//    /// Background used for the Table View Cell in country selection table
//    public static var tertiaryBackgroundColor: UIColor = .white
//    /// Main text color
//    public static var color: UIColor = .black
//    /// Secondary text color
//    public static var secondaryColor: UIColor = .lightGray
//    /// Error text color
//    public static var errorColor: UIColor = .red
//    /// Chevron color
//    public static var chevronColor: UIColor = .black
//    /// Font
//    public static var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//    /// Bar style, used for the search bar
//    public static var barStyle: UIBarStyle = UIBarStyle.default
//}
