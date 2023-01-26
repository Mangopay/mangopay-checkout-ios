// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhenTheniOSSDK",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WhenThenCoreiOS",
            targets: ["WhenThenCoreiOS"]),
        .library(
            name: "WhenThenSdkAPI",
            targets: ["WhenThenSdkAPI"]),
        .library(
            name: "WhenThenIntent",
            targets: ["WhenThenIntent"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            .upToNextMinor(from: "1.0.5")
        ),
    ],
    targets: [
        .target(
            name: "WhenThenCoreiOS",
            dependencies: [
                "WhenThenSdkAPI",
//                .product(name: "Apollo", package: "apollo-ios"),
            ],
            resources: [
                .copy("Resources/countrylistdata.json"),
                .process("Resources/Images")
            ]
        ),
        .target(
            name: "WhenThenSdkAPI",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .target(name: "WhenThenIntent")
    
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
