//
//  MangoPayiOSSDKTests.swift
//  
//
//  Created by Elikem Savie on 15/05/2023.
//

import XCTest
import MangopaySdkAPI

final class MangoPayiOSSDKTests: XCTestCase {

    var expectation: XCTestExpectation?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testValidation_date_expiration_success() {

//        let authData = AuthorizePayIn(
//            authorID: "sadqw",
//            debitedFunds: DebitedFunds(currency: "USD", amount: 20),
//            fees: DebitedFunds(currency: "USD", amount: 20),
//            creditedWalletID: "sfq31f",
//            cardID: "cardId313",
//            secureModeReturnURL: "www.google.com",
//            statementDescriptor: "sdqw",
//            ipAddress: ""
//        )
//        
//        let client = MockWhenThenClient2()
//        client.clientKey = "12345"
//        expectation = expectation(description: "attempting to authorize")
//        Task{
//            let auth = await client.authorizePayIn(authData, clientId: "12345")
//            XCTAssertEqual(auth.authorID ?? "", "sadqw")
//
//        }
    }

}

//class MockWhenThenClient2: MangoPayClientSessionProtocol {
//    var apiKey: String!
//    
//    var clientKey: String!
//    
//    func tokenizeCard(with card: MangopaySdkAPI.CheckoutSchema.PaymentCardInput, customer: MangopaySdkAPI.Customer?) async throws -> MangoPaySdkAPI.TokenizeCard {
//        let jsonData = DataDict(try! JSONObject(_jsonValue: ["token": "1234"]), variables: ["token" : "1234"])
//        let tokenised = TokenizeCard(data: jsonData)
//        return tokenised
//    }
//    
//    func createCardRegistration(_ card: MangopaySdkAPI.CardRegistration.Initiate, clientId: String, apiKey: String) async throws -> MangoPaySdkAPI.CardRegistration {
//        return CardRegistration(
//            id: "164689525",
//            creationDate: 1678862696,
//            userID: "158091557",
//            accessKey: "1X0m87dmM2LiwFgxPLBJ",
//            preregistrationData: "-3qr8M0QBM0xs1g25H_bHhMzNE3s5pZbjCwLe75jdRSIeR1WXJq8WHOx0f4EWQuW2ddFLVXdicolcUIkv_kKEA",
//            cardType: "CB_VISA_MASTERCARD",
//            cardRegistrationURLStr: "https://homologation-webpayment.payline.com/webpayment/getToken",
//            currency: "EUR",
//            status: "CREATED"
//        )
//    }
//    
//    func postCardInfo(_ cardInfo: MangopaySdkAPI.CardInfo, url: URL) async throws -> MangopaySdkAPI.CardInfo.RegistrationData {
//        return CardInfo.RegistrationData(RegistrationData: "-3qr8M0QBM0xs1g25H_bHhMzNE3s5pZbjCwLe75jdRSIeR1WXJq8WHOx")
//    }
//    
//    func updateCardInfo(_ regData: MangopaySdkAPI.CardInfo.RegistrationData, clientId: String, cardRegistrationId: String) async throws -> CardRegistration {
//        return CardRegistration(
//            id: "164689525",
//            creationDate: 1678862696,
//            userID: "158091557",
//            accessKey: "1X0m87dmM2LiwFgxPLBJ",
//            preregistrationData: regData.RegistrationData,
//            cardRegistrationURLStr: "https://homologation-webpayment.payline.com/webpayment/getToken",
//            currency: "EUR",
//            status: "CREATED"
//        )
//    }
//    
//    func authorizePayIn(_ authorizeData: AuthorizePayIn, clientId: String) async throws -> AuthorizePayIn {
//        return  AuthorizePayIn(
//            authorID: "sadqw",
//            debitedFunds: DebitedFunds(currency: "USD", amount: 20),
//            fees: DebitedFunds(currency: "USD", amount: 20),
//            creditedWalletID: "sfq31f",
//            cardID: "cardId313",
//            secureModeReturnURL: "www.google.com",
//            statementDescriptor: "sdqw",
//            ipAddress: ""
//        )
//    }
//    
//    func getPayIn(clientId: String, payInId: String) async throws -> PayIn {
//        return PayIn(
//            id: "149625824",
//            tag: "Custom description",
//            authorID: "146476890",
//            debitedFunds: CreditedFunds(currency: "USD", amount: 20),
//            creditedFunds: CreditedFunds(currency: "USD", amount: 2),
//            fees: CreditedFunds(currency: "USD", amount: 2)
//        )
//    }
//    
//    
//}
