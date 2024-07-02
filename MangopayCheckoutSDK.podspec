
Pod::Spec.new do |spec|

  spec.name         = "MangopayCheckoutSDK"
  spec.version      = "1.0.9-beta-gl-009"
  spec.summary      = "Checkout API Client, Payment Form UI and Utilities in Swift."

  spec.description  = <<-DESC
  Checkout API Client and Payment Form Utilities in Swift.
  This library contains methods to implement a payment form as well as UI elements.
                   DESC

  spec.homepage     = "https://www.mangopay.com"
  spec.license      = "MIT"

  spec.author             = { "Elikem Savie" => "elikem@menaget.com" }

  spec.platform     = :ios
  spec.ios.deployment_target = "14.0"
  spec.swift_version = '5.0'


  spec.source       = { :git => "https://gitlab.com/mangopay/dev/checkout-ios-sdk.git", :tag => "#{spec.version}", :branch => "feature/sentry" }

  spec.source_files  = "MangopayCheckoutSDK/**/*.swift"
  spec.dependency     'PayPal/PaymentButtons'
  spec.dependency     'MangopayVaultSDK', '~> 1.0.8'
  spec.exclude_files = [
  'MangopayCheckoutSDK/Resources/SPMextension.swift',
  'MangopayCheckoutSDK/Utils/Configs/Paypal/MGPPaypalOptions.swift',
  'MangopayCheckoutSDK/MangopayPaymentSheet/NonSPMPaymentFormView.swift'
  ]
  
  spec.resource_bundles = {
    'MangopayiOSSDK_MangopayCheckoutSDK' => ['MangopayCheckoutSDK/Resources/**/*.swift', 'MangopayCheckoutSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets']
  }


  spec.vendored_frameworks = "Integrations/NethoneSDK.xcframework"
end
