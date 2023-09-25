# Checkout iOS SDK



## Requirements

- iOS 13+
- Xcode 12.2
- Swift 5.3+


## Integration
Mangopay Checkout SDK can be installed via SPM(highly recomended) or Cocoa Pods.

## Swift Package Manager

Use repository URL (https://github.com/Mangopay/mangopay-ios-sdk) and select the main and wait for it to install.

## Get Started

Checkout SDK comes in 3 forms, Elements, DropIn and Headless.

# Initialize the SDK
Initialize the SDK with your ClientId and select your environment (Sandbox or Production).

    ```swift
    MangoPayCoreiOS.initialize(clientId = "your-mangopay-client-id", environment = .sandbox)
    ```
### Initialization parameters

| Argument | Type | Description |
| --- | --- | --- |
| clientId | String | Your Mangopay ClientID |
| environment | MGPEnvironment | Expected backend environment.

Default value: MGPEnvironment.sandbox

Allowed values: Environment.sandbox, Environment.production.


### Configure and present the PaymentSheet

# 1. Create a MangopayClient

    ```swift
        let mgpClient = MangopayClient(
            clientId: "your-mangopay-client-id",
            apiKey: "your-mangopay-apikey-id",
            environment: .sandbox
        )
    ```

# 2. Create a checkout Sheet instance in your viewcontroller

    ```swift
        var checkout: MGPPaymentSheet!
    ```

# 3. Initialize Chec

## Other Features


## ApplePay

1. Register for an ApplePay Merchant ID
[Register merchant ID](https://developer.apple.com/account/resources/identifiers/add/merchant)
2. Create a new Apple Pay Certificate.
3. Add the Apple Pay capability to your app.
4. provide your merchantID in either your Elements or DropIn Options 


## 3D Secure 


# Headless

Headless mode grants the developer complete control as it provides the methods to make direct network calls through the SDK

1. **Tokenization**
   ```swift
        let cardInputData = FormData(
        number: "4242424242424242",
        name: "John Smith",
        expMonth: 6,
        expYear: 23,
        cvc: 200,
        savePayment: true,
        bilingInfo: BillingInfo(
            line1: "foo",
            line2: "bar",
            city: "foobar",
            postalCode: nil,
            state: nil,
            country: "US"
        )
    )

    do {
        let tokenResponse = try await MangoPaySDK.tokenizeCard(
            apikey: "ct_test_kpOoHuu5pSzJGABP",
            card: cardInput
        )
    } catch {
        //error
    }
   ```


2. **Authorization** 
   ```swift
    let authData = AuthorisedPayment(
        orderId: nil,
        flowId: "c23700cf-25a9-4b80-8aa6-3e3169f6d896",
        amount: "20",
        currencyCode: "USD",
        paymentMethod: PaymentDtoInput(
            type: .card,
            token: <your_token>
        )
    )

    do {
        let tokenResponse = try await MangoPaySDK.authorizePayment(
            apikey: "ct_test_kpOoHuu5pSzJGABP",
            paymentData: cardInput
        )
    } catch {
        //error
    }
   ```


3. **Creating a Customer**
    ```swift
      let client = MangoPayClient(clientKey: apiKey)
        
        let cardInputData = FormData(
            number: "4242424242424242",
            name: "John Smith",
            expMonth: 6,
            expYear: 23,
            cvc: 200,
            savePayment: true,
            bilingInfo: BillingInfo(
                line1: "foo",
                line2: "bar",
                city: "foobar",
                postalCode: nil,
                state: nil,
                country: "US"
            )
        )

        let customer = Customer(email: "johnsnow@abc.com", name: "John Snow")
        
        do {
            let customerId = try await client.createCustomer(
                with: CustomerInputData(
                    card: cardInputData,
                    customer: customer
                )
            )
            return customerId
        } catch {
            throw error
        }
    ```



## **Localization**

The SDK supports localization, it detects the host app's local and automatically localises.

*We currently only support English and French*
