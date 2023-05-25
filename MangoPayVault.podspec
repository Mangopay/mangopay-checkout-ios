Pod::Spec.new do |s|
    s.name         = "MangoPayVault"
    s.version      = "0.0.50-beta"
    s.summary      = "Checkout API Client, Payment Form UI and Utilities in Swift"
    s.description  = <<-DESC
    Checkout API Client and Payment Form Utilities in Swift.
    This library contains methods to implement a payment form as well as UI elements.
                     DESC
    s.homepage     = "https://www.mangopay.com"
    s.swift_version = "5.0"
    s.license      = "MIT"
    s.author       = { "Elikem Savie" => "elikem@menaget.com" }
    s.platform     = :ios, "13.0"
    s.source       = { :git => "https://gitlab.com/mangopay/dev/checkout-ios-sdk.git", :tag => "#{s.version}", :branch => "develop" }

    s.source_files = 'MangoPayVault/*.swift'
    s.dependency    'MangoPaySdkAPI', s.version.to_s
    s.dependency    'MangoPayCoreiOS', s.version.to_s

  end
  

