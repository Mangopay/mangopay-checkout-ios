---

<aside>
<img src="/icons/square-alternate_lightgray.svg" alt="/icons/square-alternate_lightgray.svg" width="40px" /> **Prerequisites**

To use the Mangopay Checkout SDK, you’ll need:

- A Mangopay `ClientId` and API key
- A User to register the card for (see [Testing - Payment methods](https://preview-documentation.swarm.preprod.mangopay.com/docs/dev-tools/testing/payment-methods) for test cards)
- iOS 13+
- Xcode 12.2
- Swift 5.3+
</aside>

## Installation

Mangopay Checkout SDK can be installed via SPM(highly recommended) or Cocoapods.

### SPM

1. Open your Xcode project and go to *File > Swift Packages > Add Package Dependency*
2. In the prompted dialog, enter the repository URL https://github.com/Mangopay/mangopay-ios-sdk
3. Select “checkout-ios-sdk” package by checking the corresponding checkbox
4. Follow the on-screen instructions to complete the installation

### Cocoapods

Open your `podfile` and add:

```ruby
pod 'MangopayCheckoutSDK’
```

Add these sources above your podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://gitlab.com/mangopay/dev/checkout-ios-sdk'
```

## Initialize the SDK

Initialize the SDK with your `ClientId` , `NethoneMerchantIdand`and select your environment (Sandbox or Production). 

<aside>
🚨 The Initialization should only be done once for an instance of the application, We recommend putting this inside the `AppDelegate` class

</aside>

```swift

MangopayCheckoutSDK.initialize(clientId: "client_id", profillingMerchantId: "profillingMerchant_id", environment: .sandbox)
```

### Initialization parameters

| Argument | Type | Description |
| --- | --- | --- |
| clientId | String | MGPEnvironment |
| profillingMerchantId | String | The profilingMerchantId is required to initialize the Checkout SDK, even if you are not subscribed to fraud prevention. Contact Mangopay to obtain your identifier. |
| environment | Environment | Expected backend environment.

Default value: Environment.SANDBOX

Allowed values:Environment.SANDBOX, Environment.PRODUCTION |

## Configure and present the PaymentSheet

<aside>
🚨 The Checkout has an integrated fraud profiler that performs background checks and collects data on the payer's device to assess transaction risk.

On successful card tokenization, the SDK provides a `fraudProfilerId`. When making a PayIn request, add this as `ProfilingAttemptReference` to enable fraud protection.

</aside>

1. **Create a Checkout Sheet instance in your ViewController**
    
    ```swift
    var checkout: MGPPaymentSheet!
    ```
    

1. **Configure `paymentSheet` with `paymentMethodOptions`**

```swift
let paymentMethodOptions = PaymentMethodOptions(
    cardOptions: cardOptions,
    applePayOptions: applePayOptions,
    paypalOptions: paypalOptions
)
```

2.1 **Card Options Configuration**

```swift
let cardOptions = MGPCardOptions(supportedCardBrands: [.mastercard, .visa, .discover])
```

Card Options Configuration Parameters

| Argument | Type | Description |
| --- | --- | --- |
| supportedCardSchemes | Array<[CardType]> | Card schemes to be shown for Card Payment option |
| cardRegistration | CardRegistration? | You can provide CardRegistration optionally from configuration or provide it from callbacks |

2.2 ApplePay Options

```swift
      let applePayOptions = MGPApplePayOptions(
            amount: 10,
            delegate: self,
            merchantIdentifier: config.merchantID,
            merchantCapabilities: .capability3DS,
            currencyCode: "USD",
            countryCode: "US",
            supportedNetworks: [
                .masterCard,
                .visa
            ],
            requiredBillingContactFields: [.name],
            billingContact: contact,
            shippingType: .delivery
         )
```

*for ApplePay Options Parameter kindly refer to [this](https://www.notion.so/Checkout-SDK-iOS-4998a56debfe473089140e70186890bb?pvs=21) section.*

   2.3 Paypal Options Configuration

```swift
**let** paypalOptions = MGPPaypalOptions()
```

Paypal Options Configuration Parameters

| Argument | Type | Description |
| --- | --- | --- |
| color | PayPalButton.Color | Color of the paypal button. Default to gold if not provided. |
| edges | PaymentButtonEdges | Edges of the button. Default to softEdges if not provided. |
| label | PayPalButton.Label | Label displayed next to the button's logo. Default to no label. |
1. **Create a payment handler/ Callbacks**

```swift
    let callback = CallBack(
         onPaymentMethodSelected: { paymentMethod in
         },
         onTokenizationCompleted: { tokenizedData in
         
         },
             onCreateCardRegistration: { cardInfo in
             },
             onPaymentCompleted: { attemptReference, result in
         },
             onCreatePayment: { paymentMethod, attemptReference in
           switch paymentMethod {
             case .card(_):
             //
             case .payPal:
             default: return nil
             }
             },
       onCancel: {
         },
         onError: { error in
         }
     )
```

**CallBack parameters**

| Property | Type | Description |
| --- | --- | --- |
| onPaymentMethodSelected | ((PaymentMethod) -> Void) | Triggered when a payment method has been selected. |
| onTokenizationCompleted | ((TokenizedCardData) -> Void) | Triggered when a card tokenization is completed and a CardId is returned |
| onCreateCardRegistration | ((MGPCardInfo) async -> MGPCardRegistration?) | This gives developers control over making card registration creation optional during the Payment session. It is only called when the shooper clicks the "Pay" button for card payment |
| onPaymentCompleted | ((PaymentMethod, String?) async -> Payable?) | Triggered when the transaction is completed, whatever the outcome (whether successful or failed). |
| onCancelled | () -> Void)? | Called when the payment sheet is closed |
| onError |  | Triggered when an internal Checkout SDK error has occurred. |

<aside>
🚨 The Checkout has an integrated fraud profiler that performs background checks and collects data on the payer's device to assess transaction risk.

On successful card tokenization, the SDK provides a `fraudProfilerId`. When making a PayIn request, add this as `ProfilingAttemptReference` to enable fraud protection.

</aside>

1. Initialize **the PaymentSheet**

```swift
checkout = MGPPaymentSheet.create(
       paymentMethodOptions: paymentMethodOptions,
       branding: PaymentFormStyle(),
       callback: callback
   )
```

1. Present the payment Sheet

```swift
checkout.present(in: self)
```

## Card Element

The Card Element offers a ready-made component that allows you to create your own card payment experience and tokenize card payment details. With our Card Element, you can easily incorporate a custom pay button and have control over the tokenization process.

When using Card Element, you still benefit from real-time card data validation, and the ability to customize the payment form.

### 1. Create an instance of the **MangoPayCheckoutForm** Payment Form

```swift
lazy var elementForm: MGPPaymentForm = {
        let form = MGPPaymentForm(
            paymentFormStyle: PaymentFormStyle(),
            supportedCardBrands: [.visa, .mastercard, .maestro]
        )
        return form
    }()
```

MGPPaymentForm

| Property | Type | Description |
| --- | --- | --- |
| paymentFormStyle | PaymentFormStyle | Property for styling the payment form. |
| supportedCardBrands | Array<CardType> | The supported card brands listed above the payment form. |

### 2. Add payment form to your parent view and add the appropriate layout constraints

```swift
**self**.view.addSubview(elementForm)
```

### Using `MangopayCheckoutForm` with card tokenization

2.1 Create card Registration object as stated [here](https://www.notion.so/Checkout-SDK-iOS-4998a56debfe473089140e70186890bb?pvs=21)

2.2 Call tokenizeCard() when desired (Example when pay button was clicked)

```swift
    MangopayCoreiOS.tokenizeCard(
        form: elementForm,
        with: cardRegistration,
        presentIn: <presenting_view_controller>
    ) { respoonse, error in
            
      if let res = respoonse {
            //do something
      }
      
      if let err = error {
          //do something
      }
  }
```

`**MangopayCoreiOS.tokenizeCard()**`

| Property | Type | Description |
| --- | --- | --- |
| form | MangopayCheckoutForm | payment form instance |
| with | MGPCardRegistration | Card registration object |
| presentIn | UIViewController |  |
| callBack | typealias MangoPayTokenizedCallBack = ((TokenizedCardData?, MGPError?) -> ()) | A callback that handles events of the payment form tokenization process |

`**TokenizedCardData**`

| Property | Type | Description |
| --- | --- | --- |
| card | CardRegistration | Tokenized Card object |
| fraud | FraudData | FraudData object |

`**FraudData**`

| Property | Type | Description |
| --- | --- | --- |
| provider | String | Fraud Data provider (usually Nethone) |
| profilingAttemptReference | String | Attempt Reference provided by Nethone

Handling ApplePay payment |

## Handling ApplePay payment

<aside>
<img src="/icons/square-alternate_lightgray.svg" alt="/icons/square-alternate_lightgray.svg" width="40px" /> **Prerequisites**

To use the Mangopay Checkout SDK to accept ApplePay payment, you’ll need to:

- [Create merchant identifiers](https://developer.apple.com/help/account/configure-app-capabilities/configure-apple-pay#create-a-merchant-identifier) in your Apple developer account
- [Register and validate](https://developer.apple.com/documentation/applepaywebmerchantregistrationapi/preparing_merchant_domains_for_verification) your merchant domain
- [Create a merchant identity certificate](https://developer.apple.com/help/account/configure-app-capabilities/configure-apple-pay-on-the-web) associated with your merchantId
- [Set up your server](https://developer.apple.com/documentation/apple_pay_on_the_web/setting_up_your_server) for secure communication with Apple Pay and [creating merchant sessions](https://developer.apple.com/documentation/apple_pay_on_the_web/apple_pay_js_api/creating_an_apple_pay_session).
- Ask your CSM tot enable ApplePay
</aside>

To accept Apple Pay payments with Mangopay PaymentSheet, when creating an instance of the Checkout class, you can optionally include a `MGPApplePayConfig` object. This will display the ApplePay button in your payment form and handle the ApplePay tokenization process.

You will need to pass the ApplePay payment data provided by the Checkout to your Apple PayIn request from your backend. 

For more information, please refer to the "[PayIn with ApplePay" tutorial in the Mangopay documentation](https://mangopay.com/docs/tutorials/integration-guide-googlepay). 

```swift
let applePayConfig = MGPApplePayConfig(
          amount: 1,
          delegate: self,
          merchantIdentifier: "<merchant_id>",
          merchantCapabilities: .capability3DS,
          currencyCode: "<currency_code",
          countryCode: "<country_code",
          supportedNetworks: [
              .masterCard,
              .visa
          ]
       )

let paymentConfig = PaymentMethodConfig(cardReg: cardRegObj, applePayConfig: applePayConfig)

checkout = MGPPaymentSheet.create(
       client: mgpClient,
       paymentMethodConfig: paymentConfig,
       branding: PaymentFormStyle(),
       callback: callback
   )
```

### ApplePay **parameters**

| Property | Type | Description | Required |
| --- | --- | --- | --- |
| amount | Double | The amount being paid. | Y |
| delegate | MGPApplePayHandlerDelegate | The event handler. | Y |
| merchantIdentifier | String | The merchant identifier | Y |
| merchantCapabilities | PKMerchantCapability | A bit field of the payment processing protocols and card types that you support. | Y |
| currencyCode | String | The three-letter ISO 4217 currency code that determines the currency this payment request uses. | Y |
| countryCode | String | The merchant’s two-letter ISO 3166 country code. | Y |
| supportedNetworks | Array<PKPaymentNetwork> | The payment methods that you support. | Y |
| requiredBillingContactFields | Set<PKContactField> |  | N |
| billingContact | PKContact |  | N |
| shippingContact | PKContact |  | N |
| shippingType | PKShippingType |  | N |
| shippingMethods | Array<PKShippingMethod> |  | N |
| applicationData | Data |  | N |
| requiredShippingContactFields | Set<PKContactField> |  | N |

### Handling ApplePay result

```swift
extension ViewController: MGPApplePayHandlerDelegate {

    func applePayContext(didSelect shippingMethod: PKShippingMethod, handler: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
    }

    func applePayContext(didCompleteWith status: MangoPayApplePay.PaymentStatus, error: Error?) {
    }
}
```

## Process the payment

### Making card pay-ins

You can use a registered card (`CardId`) for pay-ins with the following objects:

- [The Direct Card PayIn object](https://mangopay.com/docs/endpoints/direct-card-payins#direct-card-payin-object), for one-shot card payments
- [The Recurring PayIn Registration object](https://preview-documentation.swarm.preprod.mangopay.com/docs/endpoints/recurring-card-payins#recurring-payin-registration-object), for recurring card payments
- [The Preauthorization object](https://preview-documentation.swarm.preprod.mangopay.com/docs/endpoints/preauthorizations#preauthorization-object), for 7-day preauthorized card payments
- [The Deposit Preauthorization object](https://preview-documentation.swarm.preprod.mangopay.com/docs/endpoints/preauthorizations#deposit-preauthorization-object), for 30-day preauthorized card payments

### Making GooglePay pay-ins

Include Google PaymentData provided by the Checkout in your Google PayIn: [PayIn with GooglePay](https://mangopay.com/docs/tutorials/integration-guide-googlepay#include-google-paymentdata-in-your-google-payin)

### Managing cards

You can use the following endpoints to manage cards: 

- [View a Card](https://mangopay.com/docs/endpoints/direct-card-payins#view-card) provides key information about the card, including its `Fingerprint` which can be used as an [anti-fraud tool](https://mangopay.com/docs/concepts/payments/payment-methods/card/anti-fraud-tools#card-fingerprint)
- [Deactivate a Card](https://mangopay.com/docs/endpoints/direct-card-payins#deactivate-card) allows you to irreversibly set the card as inactive

### Related resources

- [Testing - Payment methods](https://mangopay.com/docs/dev-tools/testing/payment-methods)
- [All supported payment methods](https://mangopay.com/docs/concepts/payments/payment-methods/all)

## **Handling redirection**

Some payment methods (card, PayPal) require or may require the user to be redirected to authorize or complete a transaction.

The Checkout SDK allows you to manage the entire payment flow seamlessly while retaining control over transaction logic in your backend. Once a payment method is selected and payment details are provided, use the `onCreatePayment` function to request the transaction from your backend.

Subsequently, and when necessary for the transaction type, the Checkout SDK seamlessly manages additional redirect actions for 3DS authorization or otherwise validating the payment.

To manage transaction redirects effectively with the SDK:

1. In your callback attribute, define an `onCreatePayment` attribute as a closure. The closure has `paymentMethod` and `attemptReference` as inputs and it returns the created card object
2. Within your function:
    1. Request a transaction from your server and subsequently, Mangopay. ( *you can pass in the attempt Reference in the request)*
    2. Return the unaltered transaction response object to the SDK.
3. The SDK:
    1. Redirects the user to the payment authentication page when necessary.
    2. Manages payment provider redirects back to the SDK.
    3. Triggers the `onPaymentComplete` event with the ID and status of the transaction.
    4. Confirms the redirect result on your server by invoking the corresponding GET API of the transaction.
    5. Presents the payment result to the user.
    

**Redirection example**

```swift
            callback: CallBack(
                 onCreatePayment: { paymentMethod, attemptRef in
                     // 1. implement server-side call to request a transaction (with the attempt reference).
                                     // 2. return the card transaction object.
                                     return <Card_Transaction_Object>
                 }
             )
    
```

## **Present the payment result**

```kotlin
    
Checkout Screen  -> Payment sheet -> Confirmation screen 

checkout = MGPPaymentSheet.create(
           paymentMethodOptions: paymentConfig,
           branding: PaymentFormStyle(),
           callback: CallBack(
               onTokenizationCompleted: { cardRegistration in
                                    **//dismiss the payment sheet**
                                     self.checkout.teardown()
                                    **//present the confirmation screen**
               },
               onError: { error in
               },
               onSheetDismissed: {
               }
           )
       )

       checkout.present(in: self)
```

## Customizing the Checkout

### Branding

`PaymentFormStyle` is responsible for the the styling and customization of the checkout form

```swift
let branding = PaymentFormStyle(
            font: .systemFont(ofSize: 12),
            borderType: .round,
            backgroundColor: .white,
            textColor: .gray,
            placeHolderColor: .darkGray,
            borderColor: .black,
            borderFocusedColor: .blue,
            errorColor: .red,
            checkoutButtonTextColor: .white,
            checkoutButtonBackgroundColor: .black,
            checkoutButtonDisabledBackgroundColor: .gray,
            checkoutButtonText: "Checkout",
            applePayButtonType: .plain,
            applePayButtonStyle: .black,
            applePayButtonCornerRadius: 8
         )

....

checkout = MGPPaymentSheet.create(
       client: mgpClient,
       paymentMethodConfig: paymentConfig,
       branding: branding,
       callback: callback
   )
```

| Property | Type | Description |
| --- | --- | --- |
| font | UIFont | The font of the textfields and labels in the Checkout Form |
| borderType | BorderType | The border type of the textfields. Values are (square & round) |
| textColor | UIColor | Text Color of the Textfields in the Checkout Form |
| placeHolderColor | UIColor | Textfield placeholder Color of the textfields in the Checkout Form. |
| borderColor | UIColor | Border Color of the form |
| borderFocusedColor | UIColor | Color of the Textfield when Highlighted. |
| errorColor | UIColor | Color of the error labels |
| checkoutButtonTextColor | UIColor | Color of the Checkout Button |
| checkoutButtonBackgroundColor | UIColor | Background Color of the Checkout Button |
| checkoutButtonDisabledBackgroundColor | UIColor | Disabled color of the Checkout Button |
| checkoutButtonText | String | Checkout Button Text |
| checkoutTitleText | String | Checkout Header Text |
| applePayButtonType | PKPaymentButtonType | Apple Pay Button Type |
| applePayButtonStyle | PKPaymentButtonStyle | Apple Pay Button Style |
| applePayButtonCornerRadius | CGFloat | Apple Pay Corner Radius |

### Localisation
