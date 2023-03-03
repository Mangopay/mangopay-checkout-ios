// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MongoPayiOSSDK",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MongoPayCoreiOS",
            targets: ["MongoPayCoreiOS", "NethoneSDK"]),
        .library(
            name: "MongoPaySdkAPI",
            targets: ["MongoPaySdkAPI"]),
        .library(
            name: "MongoPayIntent",
            targets: ["MongoPayIntent"]),
        .library(
            name: "MangoPayVault",
            targets: ["MangoPayVault"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            .upToNextMinor(from: "1.0.5")
        ),
    ],
    targets: [
        .target(
            name: "MongoPayCoreiOS",
            dependencies: [
                "MongoPaySdkAPI",
            ],
            resources: [
                .copy("Resources/countrylistdata.json"),
                .process("Resources/Images")
            ]
        ),
        .target(
            name: "MongoPaySdkAPI",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .target(
            name: "MongoPayIntent",
            dependencies: [
                "MongoPaySdkAPI",
            ]
        ),
        .target(
            name: "MangoPayVault",
            dependencies: [
                "MongoPaySdkAPI",
                "MongoPayCoreiOS"
            ]
        ),
        .binaryTarget(
            name: "NethoneSDK",
            path: "Integrations/NethoneSDK.xcframework"
        ),
    
//        .testTarget(
//            name: "checkout-ios-sdkTests",
//            dependencies: ["checkout-ios-sdk"]),
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
