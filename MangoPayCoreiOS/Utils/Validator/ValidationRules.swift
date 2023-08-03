//
//  File.swift
//  
//
//  Created by Elikem Savie on 17/10/2022.
//

import Foundation


public enum ValidationRules: String {

    case invalidCardNumber
    case cardNumberRequired
    case cardMinimmun
    case fullNameRequired
    case cardExpired
    case cvvRequired
    case dateRequired
    case dateExpired
    case textTooShort
    case fieldRequired

    var reason: String {
        switch self {
        case .invalidCardNumber:
            return "LocalizableString.ERROR_CARD_NUMBER_INVALID"
        case .cardNumberRequired:
            return "LocalizableString.ERROR_CARD_NUMBER_INVALID"
        case .cardMinimmun:
            return "LocalizableString.ERROR_CARD_MIN_NUMBER"
        case .fullNameRequired:
            return "LocalizableString.ERROR_FULLNAME_REQUIRED"
        case .cardExpired:
            return "LocalizableString.ERROR_CARD_EXPIRED"
        case .cvvRequired:
            return "LocalizableString.ERROR_CVC_REQUIRED"
        case .dateRequired:
            return "LocalizableString.ERROR_EXPIRED_DATE_REQUIRED"
        case .dateExpired:
            return "LocalizableString.ERROR_EXPIRED_DATE"
        case .textTooShort:
            return "LocalizableString.ERROR_TEXT_TOO_SHORT"
        case .fieldRequired:
            return "Field required"
        }
    }
}

public protocol Validatable {
    var validationRules: [ValidationRules] { get set }
    var inputData: String { get }
    var identifier: String { get }
    func containsValidInput() -> Bool
    func containsValidInputWithError() -> Bool
    func triggerError(message: String)
}

public protocol FormValidatable {
    var forms: [Validatable] { get set }
    func areFormsValid() -> Bool
    func areFormsValidShowingError() -> Bool
    func isFormValid(_ form: Validatable) -> Bool
}

extension FormValidatable {
    public func areFormsValid() -> Bool {
        return !forms.contains(where: {$0.containsValidInput() == false})
    }

    public func areFormsValidShowingError() -> Bool {
        forms.forEach({$0.containsValidInputWithError()})
        return !forms.contains(where: {$0.containsValidInput() == false})
    }

    public func isFormValid(_ form: Validatable) -> Bool {
        let _form = forms.first(where: {$0.identifier == form.identifier})
        let _ = _form?.containsValidInputWithError()
        return _form?.containsValidInput() ?? false
    }
}


extension Validatable {
    @discardableResult
    public func containsValidInput() -> Bool {
        let validator = Validator(item: self)
        return validator.isValid(triggeringError: false)
    }

    @discardableResult
    public func containsValidInputWithError() -> Bool {
        let validator = Validator(item: self)
        return validator.isValid(triggeringError: true)
    }
}

class Validator<T: Validatable> {

    let item: T

    public init(item: T) {
        self.item = item
    }
    
    public func validate(using rule: ValidationRules, triggerError: Bool) -> Bool {
        switch rule {
        case .invalidCardNumber:
            let cardNumber = item.inputData
            let isValid = cardNumber.count >= 13
            (triggerError && !isValid) ? item.triggerError(message: rule.reason) : ()
            return isValid
        case .cardNumberRequired, .fullNameRequired, .fieldRequired, .cvvRequired, .dateRequired:
            let isEmpty = item.inputData.isEmpty
            (triggerError && isEmpty) ? item.triggerError(message: rule.reason) : ()
            return !isEmpty
        case .cardMinimmun:
            let cardNumber = item.inputData
            let isValid = cardNumber.count >= 13
            (triggerError && !isValid) ? item.triggerError(message: rule.reason) : ()
            return isValid
        case .cardExpired:
            return triggerError
        case .textTooShort:
            let isTooShort = item.inputData.count <= 2
            (triggerError && isTooShort) ? item.triggerError(message: rule.reason) : ()
            return !isTooShort
        case .dateExpired:
            let isValid = isExpDateValid(dateStr: item.inputData)
            (triggerError && !isValid) ? item.triggerError(message: rule.reason) : ()
            return isValid
        }
    }

    func isExpDateValid(dateStr: String) -> Bool {

        let currentYear = Calendar.current.component(.year, from: Date()) // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will
        print(dateStr) // This is MM/YY Entered by user
        
        guard let actualDate = Date(dateStr, format: "MM/yy") else { return false }
        let enteredYear = Calendar.current.dateComponents([.year], from: actualDate).year ?? 0
        let enteredMonth = Calendar.current.dateComponents([.month], from: actualDate).month ?? 0

        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                return true
            } else {
                return false
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }

    }

    public func isValid(triggeringError triggerError: Bool) -> Bool {
        return !item.validationRules.contains(
            where: { validate(using: $0, triggerError: triggerError) == false }
        )
    }
}
