//
//  File.swift
//  
//
//  Created by Elikem Savie on 17/10/2022.
//

import Foundation

struct LuhnChecker {
    
    func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1
                
                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }
    
    public static func getCreditCardType(cardNumber: String) -> CardType {
        
        let VISA_Regex = "^4\\d*$"
        let MasterCard_Regex = "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)\\d*$"
        let AmericanExpress_Regex = "^3[47]\\d*$"
        let DinersClub_Regex = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        let Discover_Regex = "^(6011|65|64[4-9])\\d*$"
        let JCB_Regex = "^(2131|1800|35)\\d*$"
        let diner = "^3(0[0-5]|[689])\\d*$"
        let unionPay = "^(((620|(621(?!83|88|98|99))|622(?!06|018)|62[3-6]|627[02,06,07]|628(?!0|1)|629[1,2]))\\d*|622018\\d{12})$"
        let maestro = "^(?:5[06789]\\d\\d|(?!6011[0234])(?!60117[4789])(?!60118[6789])(?!60119)(?!64[456789])(?!65)6\\d{3})\\d{8,15}$"
    
        print("🤣 cardNumber", cardNumber)
        if cardNumber.isMatch(VISA_Regex) {
            return .visa
        } else if cardNumber.isMatch(MasterCard_Regex) {
            return .mastercard
        } else if cardNumber.isMatch(AmericanExpress_Regex) {
            return .amex
        } else if cardNumber.isMatch(DinersClub_Regex) {
            return .diner
        } else if cardNumber.isMatch(Discover_Regex) {
            return .discover
        } else if cardNumber.isMatch(JCB_Regex) {
            return .jcb
        } else {
            return .none
        }
        
    }
}
