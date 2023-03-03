import Foundation

public struct CardInfo: Codable {
    public var accessKeyRef: String?
    public var data: String?
    public var cardNumber: String?
    public var cardExpirationDate: String?
    public var cardCvx: String?
    public var cardType: String?

    public struct RegistrationData: Codable {
        public let RegistrationData: String
    }

    public init(accessKeyRef: String? = nil, data: String? = nil, cardNumber: String? = nil, cardExpirationDate: String? = nil, cardCvx: String? = nil, cardType: String? = nil) {
        self.accessKeyRef = accessKeyRef
        self.data = data
        self.cardNumber = cardNumber
        self.cardExpirationDate = cardExpirationDate
        self.cardCvx = cardCvx
        self.cardType = cardType
    }
}
