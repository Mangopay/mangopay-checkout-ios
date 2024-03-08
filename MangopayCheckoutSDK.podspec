
Pod::Spec.new do |spec|

  spec.name         = "MangopayCheckoutSDK"
  spec.version      = "1.0.0-beta.20"
  spec.summary      = "Checkout API Client, Payment Form UI and Utilities in Swift."

  spec.description  = <<-DESC
  Checkout API Client and Payment Form Utilities in Swift.
  This library contains methods to implement a payment form as well as UI elements.
                   DESC

  spec.homepage     = "https://www.mangopay.com"
  spec.license      = "MIT"

  spec.author             = { "Elikem Savie" => "elikem@menaget.com" }

  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"
  spec.swift_version = '5.0'


  spec.source       = { :git => "https://gitlab.com/mangopay/dev/checkout-ios-sdk.git", :tag => "#{spec.version}", :branch => "cocoapod_update" }

  spec.source_files  = "MangopayCheckoutSDK/**/*.swift"
  spec.dependency     'MangopayVaultSDK', '~> 1.0.8'

  
  spec.resource_bundle = {
    'MangopayCheckoutSDK' => ['MangopayCheckoutSDK/Resources/**/*.swift', 'MangopayCheckoutSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets']
  }


  spec.vendored_frameworks = "Integrations/NethoneSDK.xcframework"
end
