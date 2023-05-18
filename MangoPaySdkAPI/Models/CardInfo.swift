import Foundation

public protocol Cardable {
    var cardNumber: String? { get }
    var cardExpirationDate: String? { get }
    var cvc: String? { get }
}

public struct CardInfo: Codable, Cardable {
    
    public var cardNumber: String?
    public var cardExpirationDate: String?
    public var cardCvx: String?
    public var cardType: String?
    public var accessKeyRef: String?
    public var data: String?

    public var cvc: String? {
        return cardCvx
    }

    public var monthInt: Int {
        guard let str = cardExpirationDate else { return 1 }
        let monthStr = String(str.prefix(2))
        return Int(monthStr) ?? 0
    }

    public var yearInt: Int {
        guard let str = cardExpirationDate else { return 1 }
        let yearStr = String(str.suffix(2))
        return Int(yearStr) ?? 0
    }

    public struct RegistrationData: Codable {
        public let RegistrationData: String
        
        public init(RegistrationData: String) {
            self.RegistrationData = RegistrationData
        }
    }

    public init(
        cardNumber: String? = nil,
        cardExpirationDate: String? = nil,
        cardCvx: String? = nil,
        cardType: String? = nil,
        accessKeyRef: String? = nil,
        data: String? = nil
    ) {
        self.cardNumber = cardNumber
        self.cardExpirationDate = cardExpirationDate
        self.cardCvx = cardCvx
        self.cardType = cardType
        self.accessKeyRef = accessKeyRef
        self.data = data
    }
}

