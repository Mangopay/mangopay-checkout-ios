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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidation_date_expiration_success() {

        let cardInfo = CardInfo(
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
        )

        let isvalid = (try? mgpVault.validateCard(with: cardInfo)) ?? false
        XCTAssertTrue(isvalid)
    }

    func testValidation_date_expiration_failure() {

        let cardInfo = CardInfo(
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1020",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4129939187355598",
            cardExpirationDate: "1024",
            cardCvx: "123"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "1234"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024",
            cardCvx: "12899"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
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
            accessKeyRef: cardRegObject.accessKey,
            data: cardRegObject.preregistrationData,
            cardNumber: "4970101122334422",
            cardExpirationDate: "1024"
        )
        
        let mgpVault = MangoPayVault(
            clientToken: "checkoutsquatest",
            provider: .MANGOPAY
        )

        do {
            let isvalid = try mgpVault.validateCard(with: cardInfo)
            XCTAssertFalse(isvalid)
        } catch {
            let valError = error as! CardValidationError
            XCTAssertTrue(valError == CardValidationError.cvvRqd)
        }
    }
}
