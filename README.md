# Checkout iOS SDK



## Requirements

- iOS 13+
- Xcode 12.2
- Swift 5.3+


## Integration
MangoPay Checkout SDK can be installed via SPM(highly recomended) or Cocoa Pods.

## Swift Package Manager

Use repository URL (https://github.com/checkout/frames-ios) and select range of versions `1.0.0` and wait for it to install.

## Get Started

Checkout SDK comes in 3 forms, Elements, DropIn and Headless.

# Elements & DropIn

1. Import Checkout SDK 

    ```swift
    import checkout_ios_sdk
    ```

2. Set the supported Card Brands
    ```swift
    let cardConfig = CardConfig(supportedCardBrands: [.visa, .amex])
    ```

3. Set the Forms Styling through the `PaymentFormStyle` object.

    ```swift
    let style = PaymentFormStyle(
        font: .systemFont(ofSize: 10),
        borderType: .round,
        textColor: .black,
        placeHolderColor: .gray,
        errorColor: .red,
        checkoutButtonTextColor: .white,
        checkoutButtonBackgroundColor: .black
    )
    ```

4. Set the Element Options

   i. This configuration aids in:
    - ensuring you receive access for the request
    - enable us to prevalidate supported schemes at input stage
    - prefill user information (Optional but may go a long way with User Experience if able to provide)
    - Respond to events (with the delegates)

```swift
let elementOptions = ElementsOptions(
        apiKey: "<Your Public Key>",
        style: style,
        customerId: nil,
        amount: 200,
        currencyCode: "USD",
        delegate: self
)
```

  ii. Setup Elements Event Delegates
  ```swift
    extension ViewController: ElementsFormDelegate {
        func onPaymentStarted(sender: PaymentFormViewModel, payment: GetPayment) {
            
        }

        func onApplePayCompleteElement(status: MangoPayApplePay.PaymentStatus) {

        }

        func onTokenGenerated(tokenizedCard: tokenizeCard) {
            print("Element Token Succesfully Generated \(tokenizedCard.token)")
        }

        func onTokenGenerationFailed(error: Error) {
            print("Element Token Failed")
        }

    }
  ```

5. Set the Dropin Options 
    i. The dropin Configuration comes with extra params for `orderId`, `threeDSRedirectURL` and `flowId`. To handle 3DS, you will have to provide a `threeDSRedirectURL` a URL.

    ```swift
        let dropInOptions = DropInOptions(
            apiKey: <your_public_key>,
            orderId: nil,
            style: style,
            customerId: nil,
            flowId: <your_flowID>,
            amount: 2000,
            currencyCode: "USD",
            countryCode: "US",
            threeDSRedirectURL: <your_redirect_url>,
            delegate: self
        )
    ```

    ii. Setup Event Delegates
    ```swift
        extension ViewController: DropInFormDelegate {

        func onPaymentStarted(sender: PaymentFormViewModel) {
            
        }
        
        func onApplePayCompleteDropIn(status: MangoPayApplePay.PaymentStatus) {
            //success
            //error
            //userCancellation
        }
        

        func onPaymentCompleted(sender: PaymentFormViewModel, payment: GetPayment) {
        }

        func onPaymentFailed(sender: PaymentFormViewModel, error: MangoPayError) {
        }
        
    }
    ```


6. Present in Host Controller

    ```swift
    MangoPaySDK.buildDropInForm(
        with: dropInOptions,
        cardConfig: cardConfig,
        present: self,
        dropInDelegate: self
    )
    ```

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
