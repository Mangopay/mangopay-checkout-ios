Pod::Spec.new do |s|
    s.name         = "WhenThen-ios-sdk"
    s.version      = "0.0.1"
    s.summary      = "Checkout API Client, Payment Form UI and Utilities in Swift"
    s.description  = <<-DESC
    Checkout API Client and Payment Form Utilities in Swift.
    This library contains methods to implement a payment form as well as UI elements.
                     DESC
    s.homepage     = "https://whenthen.com"
    s.swift_version = "5.0"
    s.license      = "MIT"
    s.author       = { "Checkout.com Integration" => "integration@checkout.com" }
    s.platform     = :ios, "10.0"
    s.source       = { :git => "https://gitlab.com/whenthen/checkout-ios-sdk", :tag => s.version }
  
    s.source_files = 'Sources/**/*.swift'
  end
  
