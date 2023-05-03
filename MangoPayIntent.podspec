Pod::Spec.new do |s|
    s.name         = "MangoPayIntent"
    s.version      = "0.0.37-beta"
    s.summary      = "Checkout API Client, Payment Form UI and Utilities in Swift"
    s.description  = <<-DESC
    Checkout API Client and Payment Form Utilities in Swift.
    This library contains methods to implement qa payment form as well as UI elements.
                     DESC
    s.homepage     = "https://www.mangopay.com"
    s.swift_version = "5.0"
    s.license      = "MIT"
    s.author       = { "Checkout.com Integration" => "integration@checkout.com" }
    s.platform     = :ios, "13.0"
    s.source       = { :git => "https://gitlab.com/whenthen/checkout-ios-sdk", :tag => s.version, :branch => "feature/cocoapod_deployment" }

    s.source_files = 'MangoPayIntent/*.swift'

  end
  

