// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MangopayiOSSDK",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MangopayCoreiOS",
            targets: ["MangopayCoreiOS", "NethoneSDK"]),
        .library(
            name: "MangopaySdkAPI",
            targets: ["MangopaySdkAPI"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/Mangopay/mangopay-ios-vault-sdk", branch: "main"),
    ],
    targets: [
        .target(
            name: "MangopayCoreiOS",
            dependencies: [
                "MangopaySdkAPI",
                .product(name: "MangopayVault", package: "mangopay-ios-vault-sdk"),
            ],
            path: "MangopayCoreiOS",
            resources: [
                .copy("Resources/countrylistdata.json"),
                .process("Resources/Images")
            ]
        ),
        .target(
            name: "MangopaySdkAPI",
            dependencies: [
                .product(name: "MangopayVault", package: "mangopay-ios-vault-sdk")
            ],
            path: "MangopaySdkAPI"
        ),
        .binaryTarget(
            name: "NethoneSDK",
            path: "Integrations/NethoneSDK.xcframework"
        ),
        .testTarget(
            name: "Tests",
            dependencies: [
                "MangopaySdkAPI",
                "MangopayCoreiOS"
            ],
            path: "Tests"
//            swiftSettings: [
//                .unsafeFlags(["-enable-testing-search-paths"]),
//            ]
        )

//        .plugin(name: "SwiftLintCommandPlugin.swift",
//                capability: .command(
//                    intent: .sourceCodeFormatting(),
//                    permissions: [
//                        .writeToPackageDirectory(reason: "This command reformats source files")
//                    ]
//                )
//               )
        
    ]
)
