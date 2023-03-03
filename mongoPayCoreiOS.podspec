Pod::Spec.new do |s|
    s.name         = "MongoPayCoreiOS"
    s.version      = "0.0.1"
    s.summary      = "Checkout API Client, Payment Form UI and Utilities in Swift"
    s.description  = <<-DESC
    Checkout API Client and Payment Form Utilities in Swift.
    This library contains methods to implement a payment form as well as UI elements.
                     DESC
    s.homepage     = "https://www.mangopay.com"
    s.swift_version = "5.0"
    s.license      = "MIT"
    s.author       = { "Elikem Savie" => "elikem@menaget.com" }
    s.platform     = :ios, "10.0"
    s.source       = { :git => "https://gitlab.com/whenthen/checkout-ios-sdk", :tag => s.version }
  
    s.source_files = 'Sources/MongoPayCoreiOS/*.swift'

    s.dependency                       'mongoPayCoreiOS', s.version.to_s
    s.dependency                       'MongoPayiOSSDK', s.version.to_s
    s.dependency                       'mongoPaySdkAPI', s.version.to_s
    s.dependency                       'mangoPayVault', s.version.to_s
  end
  