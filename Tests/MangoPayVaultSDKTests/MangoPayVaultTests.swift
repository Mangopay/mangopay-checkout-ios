//
//  MangoPayValut.swift
//  
//
//  Created by Elikem Savie on 23/03/2023.
//

import XCTest
@testable import MangoPayVault
@testable import MangoPaySdkAPI
@testable import MangoPayCoreiOS
import Combine

final class MangoPayVaultTests: XCTestCase {

    var cardRegObject: CardRegistration {
        return CardRegistration(
            id: "164689525",
            creationDate: 1678862696,
            userID: "158091557",
            accessKey: "1X0m87dmM2LiwFgxPLBJ",
            preregistrationData: "-3qr8M0QBM0xs1g25H_bHhMzNE3s5pZbjCwLe75jdRSIeR1WXJq8WHOx0f4EWQuW2ddFLVXdicolcUIkv_kKEA",
            cardType: "CB_VISA_MASTERCARD",
            cardRegistrationURLStr: "https://homologation-webpayment.payline.com/webpayment/getToken",
            currency: "EUR",
            status: "CREATED"
        )
    }

    var cardInfo: CardInfo {
        return CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
    }

    var isSuccessful = false
    var token: String?
    var expectation: XCTestExpectation?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidation_date_expiration_success() {

        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        let isvalid = (try? mgpVault.validateCard(with: cardInfo)) ?? false
        XCTAssertTrue(isvalid)
    }

    func testValidation_date_expiration_failure() {

        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1020",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertFalse(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError == CardValidationError.expDateInvalid)
        }
    }

    func testValidation_date_expiration_required_success() {
        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertTrue(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError != CardValidationError.expDateRqd)
        }
    }

    func testValidation_date_expiration_required_failure() {
        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertFalse(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError == CardValidationError.expDateRqd)
        }
    }

    func testValidation_cardNumber_required_success() {
        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertTrue(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError != CardValidationError.cardNumberRqd)
        }
    }

    func testValidation_cardNumber_required_failure() {
        let cardInfo = CardInfo(
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertFalse(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError == CardValidationError.cardNumberRqd)
        }
    }

    func testValidation_cardNumber_valid_success() {
        let cardInfo = CardInfo(
            cardNumber: "42424242424242",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertTrue(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError != CardValidationError.cardNumberInvalid)
        }
    }

    func testValidation_cardNumber_valid_failure() {
        let cardInfo = CardInfo(
            cardNumber: "4129939187355598",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertFalse(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError == CardValidationError.cardNumberInvalid)
        }
    }

    func testValidation_cvv_valid_success() {
        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "1234"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertTrue(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError != CardValidationError.cvvInvalid)
        }
    }

    func testValidation_cvv_valid_failure() {
        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "12899"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertFalse(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError == CardValidationError.cvvInvalid)
        }
    }

    func testValidation_cvv_required_failure() {
        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertFalse(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError == CardValidationError.cvvRqd)
        }
    }

    func testTokeniseWhenThen() {
        let mgpVault = MangoPayVault(
            clientId: "checkoutsquatest",
            provider: .WHENTHEN,
            environment: .sandbox
        )

        let cardData = CardData(
            number: "4970101122334422",
            name: "John",
            expMonth: 03,
            expYear: 25,
            cvc: "123",
            savePayment: false,
            bilingInfo: nil
        )

        let mockVC = MockViewController()
        
        mgpVault.setWtClient(wtClient: MockWhenThenClient(clientKey: "qwert123"))

        expectation = expectation(description: "Tokenising WT")
        mockVC.expectation = expectation
        mgpVault.tokeniseCard(
            card: cardData,
            whenThenDelegate: mockVC
        )
        
        waitForExpectations(timeout: 5)

        XCTAssertTrue(mockVC.isSuccessful)
        XCTAssertEqual(mockVC.token, "1234")
    }

    func testTokeniseMGPVault() {
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY,
            environment: .sandbox
        )

        let cardInfo = CardInfo(
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )

        let mockVC = MockPaylineController()
        
        mgpVault.setPaylineClient(paylineClient: MockVaultClient())

        expectation = expectation(description: "Tokenising Payline")
        mockVC.expectation = expectation
        mgpVault.tokeniseCard(
            card: cardInfo,
            paylineDelegate: mockVC
        )
        
        waitForExpectations(timeout: 5)

        XCTAssertTrue(mockVC.isSuccessful)
    }
    
}

class MockViewController: UIViewController, MangoPayVaultWTTokenisationDelegate {

    var isSuccessful = false
    var token: String?
    var expectation: XCTestExpectation?

    func updateExpectation() {
        
    }

    func onSuccess(tokenisedCard: MangoPaySdkAPI.TokeniseCard) {
        isSuccessful = true
        token = tokenisedCard.token
        expectation?.fulfill() // 8
        expectation = nil
    }
    
    func onFailure(error: Error) {
        isSuccessful = false
    }
    
}

class MockPaylineController: UIViewController, MangoPayVaultDelegate {
    
    var isSuccessful = false
    var token: String?
    var expectation: XCTestExpectation?

    func updateExpectation() {
        
    }
    
    func onSuccess(card: MangoPaySdkAPI.CardRegistration) {
        isSuccessful = true
        expectation?.fulfill()
        expectation = nil

    }
    
    func onFailure(error: Error) {
        isSuccessful = false
    }
    
}

class MockWhenThenClient: WhenThenClientSessionProtocol {
    var clientKey: String!
    
    init(clientKey: String) {
        self.clientKey = clientKey
    }
    
    func tokenizeCard(
        with card: MangoPaySdkAPI.CheckoutSchema.PaymentCardInput,
        customer: MangoPaySdkAPI.Customer?
    ) async throws -> MangoPaySdkAPI.TokeniseCard {
        let jsonData = DataDict(try! JSONObject(_jsonValue: ["token": "1234"]), variables: ["token" : "1234"])
        let tokenised = TokeniseCard(data: jsonData)
        return tokenised
    }
    
}

class MockVaultClient: CardRegistrationClientProtocol {

    func createCardRegistration(_ card: MangoPaySdkAPI.CardRegistration, clientId: String, apiKey: String) async throws -> MangoPaySdkAPI.CardRegistration {
        return CardRegistration(
            id: "164689525",
            creationDate: 1678862696,
            userID: "158091557",
            accessKey: "1X0m87dmM2LiwFgxPLBJ",
            preregistrationData: "-3qr8M0QBM0xs1g25H_bHhMzNE3s5pZbjCwLe75jdRSIeR1WXJq8WHOx0f4EWQuW2ddFLVXdicolcUIkv_kKEA",
            cardType: "CB_VISA_MASTERCARD",
            cardRegistrationURLStr: "https://homologation-webpayment.payline.com/webpayment/getToken",
            currency: "EUR",
            status: "CREATED"
        )
    }
    
    func postCardInfo(_ cardInfo: MangoPaySdkAPI.CardInfo, url: URL) async throws -> MangoPaySdkAPI.CardInfo.RegistrationData {
        return CardInfo.RegistrationData(RegistrationData: "-3qr8M0QBM0xs1g25H_bHhMzNE3s5pZbjCwLe75jdRSIeR1WXJq8WHOx")
    }
    
    func updateCardInfo(_ regData: MangoPaySdkAPI.CardInfo.RegistrationData, clientId: String, cardRegistrationId: String) async throws -> MangoPaySdkAPI.CardRegistration {
        return CardRegistration(
            id: "164689525",
            creationDate: 1678862696,
            userID: "158091557",
            accessKey: "1X0m87dmM2LiwFgxPLBJ",
            preregistrationData: regData.RegistrationData,
            cardRegistrationURLStr: "https://homologation-webpayment.payline.com/webpayment/getToken",
            currency: "EUR",
            status: "CREATED"
        )
    }
    
}

