// swift-tools-version: 5.7
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
            targets: ["MangopayCheckoutSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/Mangopay/mangopay-ios-vault-sdk", branch: "main"),
        .package(url: "https://github.com/paypal/paypal-ios/", branch: "main"),
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.22.2"),
        .package(id: "Nethone.NethoneSDK", from: "2.16.0")
    ],
    targets: [
        .target(
            name: "MangopayCheckoutSDK",
            dependencies: [
                .product(name: "MangopayVaultSDK", package: "mangopay-ios-vault-sdk"),
                .product(name: "PaymentButtons", package: "paypal-ios"),
                .product(name: "Sentry", package: "sentry-cocoa"),
                .product(name: "NethoneSDK", package: "Nethone.NethoneSDK")
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
        .target(
            name: "NethoneSDK",
            dependencies: [
                .product(name: "NethoneSDK", package: "Nethone.NethoneSDK")
            ]
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
