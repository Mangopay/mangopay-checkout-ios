
Pod::Spec.new do |spec|

  spec.name         = "MangoPayCoreiOS"
  spec.version      = "0.0.4"
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

  spec.source       = { :git => "https://gitlab.com/whenthen/checkout-ios-sdk", :tag => spec.version, :branch => "feature/cocoapod_deployment" }
  spec.source_files  = "MangoPayCoreiOS/*.swift"

end
