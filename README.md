# Checkout iOS SDK



## Requirements

- iOS 13+
- Xcode 12.2
- Swift 5.3+


## Installation

Mangopay Checkout SDK can be installed via SPM(highly recommended) or Cocoapods.

### SPM

1. Open your Xcode project and go to *File > Swift Packages > Add Package Dependency*
2. In the prompted dialog, enter the repository URL https://github.com/Mangopay/mangopay-ios-sdk
3. Select “checkout-ios-sdk” package by checking the corresponding checkbox
4. Follow the on-screen instructions to complete the installation
5. In your project settings, under “General”, go to “Frameworks, Libraries and Embedded Content” and select the highlighted frameworks in the picture below.
    
    ![Screenshot 2023-09-21 at 5.19.23 PM.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/5d175acb-5a02-40ea-967c-a1e5796667c4/7ef7214c-251f-4b61-83ea-3dfe476f8d17/Screenshot_2023-09-21_at_5.19.23_PM.png)
    

## Creating a Card Registration

In your backend, create a Card Registration via the Mangopay API, using the `Id` of the end user as the `UserId` .

You must also define the currency and type of the card at this stage.

<aside>
<img src="/icons/square-alternate_gray.svg" alt="/icons/square-alternate_gray.svg" width="40px" /> **POST** /v2.01/`ClientId`/cardregistrations

```json
{
    "Tag": "Created with the Mangopay Vault SDK",
    "UserId": "142036728",
    "CardType": "CB_VISA_MASTERCARD",
    "Currency": "EUR"
}
```

[See parameter details →](https://preview-documentation.swarm.preprod.mangopay.com/docs/endpoints/direct-card-payins#create-card-registration)

</aside>

### API response

```json
{
    "Id": "193020188",
    "Tag": null,
    "CreationDate": 1686147148,
    "UserId": "193020185",
    "AccessKey": "1X0m87dmM2LiwFgxPLBJ",
    "PreregistrationData": "XBDYiG8w9PrylPS01KmupZunmK2QRHKIC-yUF6il3aIpAnKba1TGkR9VJe5lHjHt2ddFLVXdicolcUIkv_kKEA",
    "RegistrationData": null,
    "CardId": null,
    "CardType": "CB_VISA_MASTERCARD",
    "CardRegistrationURL": "https://homologation-webpayment.payline.com/webpayment/getToken",
    "ResultCode": null,
    "ResultMessage": null,
    "Currency": "EUR",
    "Status": "CREATED"
}
```

The data obtained in the response will be used in the `CardRegistration` configuration of of the Checkout.

## Initialize the SDK

Initialize the SDK with your `ClientId` and select your environment (Sandbox or Production). 

```swift
MangopayCheckoutSDK.initialize(clientId: "<client_id>", environment: .sandbox)
```

### Initialization parameters

| Argument | Type | Description |
| --- | --- | --- |
| clientId | String | MGPEnvironment |
| environment | Environment | Expected backend environment.

Default value: Environment.SANDBOX

Allowed values:Environment.SANDBOX, Environment.PRODUCTION |

## Configure and present the PaymentSheet

1. **Create a Checkout Sheet instance in your ViewController**
    
    ```swift
    var checkout: MGPPaymentSheet!
    ```
    
2. **Create a payment handler/ Callbacks**

```swift
    let callback = CallBack(
         onPaymentMethodSelected: { paymentMethod in
         },
         onTokenizationCompleted: { cardRegistration in
         }, onPaymentCompleted: {
         }, onCancelled: {
         },
         onError: { error in
         },
         onSheetDismissed: {
         }
     )
```

<aside>
🚨 The Checkout has an integrated fraud profiler that performs background checks and collects data on the payer's device to assess transaction risk.

On successful card tokenization, the SDK provides a `fraudProfilerId`. When making a PayIn request, add this as `ProfilingAttemptReference` to enable fraud protection.

</aside>

1. Create a paymentMethodConfig object

```swift
let paymentConfig = PaymentMethodConfig(cardReg: cardRegObj)
```

1. Initialize **the PaymentSheet**

```swift
checkout = MGPPaymentSheet.create(
       client: mgpClient,
       paymentMethodConfig: paymentConfig,
       handlePaymentFlow: false,
       branding: PaymentFormStyle(),
       callback: callback
   )
```

1. Present the payment Sheet

```swift
checkout.present(in: self)
```

### PaymentMethodConfig Parameters

Card configuration parameters

| Property | Type | Description |
| --- | --- | --- |
| card | MGPCardInfo | Card Information Object |
| cardReg | MGPCardRegistration | Card Registration Object |
| applePayConfig | MangopayApplePayConfig | Apple pay payment configuration |

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

2.1 Create card Registration object as stated [here](https://www.notion.so/Checkout-SDK-iOS-integration-guide-4998a56debfe473089140e70186890bb?pvs=21)

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

`**MangopayCheckoutSDK.tokenizeCard()**`

| Property | Type | Description |
| --- | --- | --- |
| form | MangopayCheckoutForm | payment form instance |
|  (with) cardReg | MGPCardRegistration | Card registration object |
| viewController | UIViewController |  |
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
| attemptReference | String | Attempt Reference provided by Nethone

Handling ApplePay payment |

<aside>
<img src="/icons/square-alternate_lightgray.svg" alt="/icons/square-alternate_lightgray.svg" width="40px" /> **Prerequisites**

To use the Mangopay Checkout SDK to accept ApplePay, you’ll need to:

- [Create merchant identifiers](https://developer.apple.com/help/account/configure-app-capabilities/configure-apple-pay#create-a-merchant-identifier) in your Apple developer account
- [Register and validate](https://developer.apple.com/documentation/applepaywebmerchantregistrationapi/preparing_merchant_domains_for_verification) your merchant domain
- [Create a merchant identity certificate](https://developer.apple.com/help/account/configure-app-capabilities/configure-apple-pay-on-the-web) associated with your merchantId
- [Set up your server](https://developer.apple.com/documentation/apple_pay_on_the_web/setting_up_your_server) for secure communication with Apple Pay and [creating merchant sessions](https://developer.apple.com/documentation/apple_pay_on_the_web/apple_pay_js_api/creating_an_apple_pay_session).
- ApplePay enabled by your CSM
</aside>

To accept Apple Pay payments with Mangopay PaymentSheet, when creating an instance of the Checkout class, you can optionally include a `MangopayApplePayConfig` object. This will display the ApplePay button in your payment form and handle the ApplePay tokenization process.

You will need to pass the ApplePay payment data provided by the Checkout to your Apple PayIn request from your backend. 

For more information, please refer to the "[PayIn with ApplePay" tutorial in the Mangopay documentation](https://mangopay.com/docs/tutorials/integration-guide-googlepay). 

```swift
let applePayConfig = MangopayApplePayConfig(
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

## ****Handle 3D Secure authentication (optional)****

When you request a PayIn from your server, the response will contain a `SecureModeNeeded` field indicating if 3D Secure authentication is required by the payer.

To complete 3D Secure authentication, redirect shoppers to the authentication page using the 3DS Component. When the shopper returns to your app, make a **GET**  **`/v2.01/**ClientId**/<payInType>/**PayInId` request from your server to verify the status of the payment.

You can find an example of handling 3DS redirect flow using our SDK in the `HandleThreedsActivity.tk` file from the [Mangopay iOS SDK examples](https://github.com/Mangopay/mangopay-android-sdk-examples)**.**

<aside>
⚠️ It is important that you call GET payIn from your backend (with respect to the payInType) to verify the status of the payment.

The success callback will provide you with a PayIn type and PayIn to make the request.

</aside>

```swift
let _3dsVC = ThreeDSController(
      secureModeReturnURL: <"secure_mode_url">,
      secureModeRedirectURL: "secure_mode_redirect_url",
            transactionType: .cardDirect,
      onComplete: { result in
          switch result.status {
          case .SUCCEEDED:
                            //do something
          case .FAILED:
                            //do something
          }
      }) { error in
      }

viewController.present(_3dsVC)
```

### 3DS handler parameters

| Property | Type | Description |
| --- | --- | --- |
| secureModeReturnURL | String |  |
| secureModeRedirectURL | String |  |
| transactionType | _3DSTransactionType | Enum to handle the different types of calling the payin endpoint |
| onComplete | (_3DSResult) -> () | The 3DS handler will provide you with a payInId Call ViewPayIn |
| onError | (Error?) -> () | Callback that dissipates 3DS errors. |

**_3DSTransactionType**

| Property | Description |
| --- | --- |
| cardDirect | Direct PayIn endpoint preauthorizations/card/direct |
| preauthorized | Card PreAuth |
| cardValidated | Card Validation cards/{{card_id}}/validation |

**_3DSResult**

| Property | Type | Description |
| --- | --- | --- |
| status | _3DSStatus | Values (SUCCEEDED , FAILED) |
| type | _3DSTransactionType |  |
| id | String | PayIn Id |

### ****Verify payment result****

## ****Present the payment result****

```kotlin
    
Checkout Screen  -> Payment sheet -> Confirmation screen 

checkout = MGPPaymentSheet.create(
           paymentMethodConfig: paymentConfig,
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
