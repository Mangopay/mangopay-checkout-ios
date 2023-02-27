import Foundation

struct CardInfo: Codable {
    var accessKeyRef: String?
    var data: String?
    var cardNumber: String?
    var cardExpirationDate: String?
    var cardCvx: String?
    var cardType: String?

    struct RegistrationData: Codable {
        var data: String?
    }
}
