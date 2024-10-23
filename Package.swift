// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MangopayiOSSDK",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "MangopayCheckoutSDK",
            targets: ["MangopayCheckoutSDK", "NethoneSDK"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/Mangopay/mangopay-ios-vault-sdk", from: "1.0.9"),
        .package(
            url: "https://github.com/paypal/paypal-ios/", from: "1.4.0"),
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.22.2")
    ],
    targets: [
        .target(
            name: "MangopayCheckoutSDK",
            dependencies: [
                .product(name: "MangopayVaultSDK", package: "mangopay-ios-vault-sdk"),
                .product(name: "PaymentButtons", package: "paypal-ios"),
                .product(name: "Sentry", package: "sentry-cocoa"),
            ],
            path: "MangopayCheckoutSDK",
            exclude: [
                "Resources/NonSPMExtension.swift",
                "Utils/Configs/Paypal/NonMGPPaypalOptions.swift",
                "MangopayPaymentSheet/NonSPMPaymentFormView.swift"
            ],
            resources: [
                .copy("Resources/countrylistdata.json"),
                .process("Resources/Images")
            ]
        ),
        .binaryTarget(
            name: "NethoneSDK",
            path: "Integrations/NethoneSDK.xcframework"
        ),
        .testTarget(
            name: "Tests",
            dependencies: [
                "MangopayCheckoutSDK"
            ],
            path: "Tests"
        )
    ]
)
