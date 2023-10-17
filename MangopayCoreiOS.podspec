
Pod::Spec.new do |spec|

  spec.name         = "MangopayCoreiOS"
  spec.version      = "1.0.0-beta.1"
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

  spec.source       = { :git => "https://gitlab.com/mangopay/dev/checkout-ios-sdk.git", :tag => "#{spec.version}", :branch => "develop" }

  spec.source_files  = "MangopayCoreiOS/UI/Validator/LuhnChecker.swift", "MangopayCoreiOS/Extensions/*.swift"
  
  spec.dependency    'MangopaySdkAPI', spec.version.to_s
  spec.resources = "MangopayCoreiOS/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"


end
