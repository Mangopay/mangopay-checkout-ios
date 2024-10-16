# 🔀 &nbsp; Changelog

## 1.1.0 (2024-05-09)

### Features & Improvements
  
 * PayPal payment method support: Added the ability for customers to pay via PayPal in addition to credit/debit cards. PayPal is now available as a payment option during the checkout flow.
    
 * Introduced new `onPaymentComplete` event: Developers can now listen for the `onPaymentComplete` event, which is triggered after a payment is successfully completed. This allows for customized post-payment logic or analytics tracking.
    
* Introduced new `onCreateCardRegistration` delegate: The `onCreateCardRegistration` delegate gives developers control over making card registration creation optional during the Payment session. It is only called when the shooper clicks the "Pay" button for card payment.
    
* Introduced new `onCreatePayment` delegate: The `onCreatePayment` delegate is called when the user is ready to pay. Developers can use this to make a backend request for the transaction details and return the corresponding payment method object.
    
* Improved 3DS workflow: The 3D Secure (3DS) authentication workflow for card payments is now handled entirely within the SDK. Developers no longer need to separately install and integrate a 3DS component.
    
* Introduced `profillingMerchantId`: When initializing the SDK, developers must now provide a `profillingMerchantId` for risk profiling and fraud prevention purposes.
    
* Added support for CB (Cartes Bancaires): The CB (Cartes Bancaires) card network has been added to the list of `supportedCardBrands`.
    
* Renamed `paymentConfiguration` to `amount`: The paymentConfiguration option in the configuration object has been renamed to `amount` for clarity.

* Added currency support for card payments: Support has been added for the following currencies for card payments: AED, AUD, CAD, CHF, DKK, EUR, GBP, HKD, JPY, NOK, PLN, SEK.

* Added Sentry Event Logging for Analytics and product improvements.

* Updated Demo Project, streamlined it to be easily inferable.


## 1.1.1 (2024-07-08)

### Improvements

* Made card expiry field more intuitive

## 1.1.2 (2024-07-19)

### Improvements

* More improvement to UX of expiry card field

##1.1.3 (2024-10-14)

### Improvements

* Added tags to sentry logs to enhance easy classification.

* Ensured consistent sizing for all card icons.

* Migrated & updated NethoneSDk from xcframework to SPM package.
