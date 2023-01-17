// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhenThen-ios-sdk",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WhenThen-ios-core",
            targets: ["WhenThen-ios-core"]),
        .library(
            name: "WhenThen-sdk-api",
            targets: ["WhenThen-sdk-api"]),
        .library(
            name: "WhenThen-Intent",
            targets: ["WhenThen-Intent"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            .upToNextMinor(from: "1.0.5")
        ),
    ],
    targets: [
        .target(
            name: "WhenThen-ios-core",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ],
            resources: [
                .copy("Resources/countrylistdata.json"),
                .process("Resources/Images")
            ]
        ),
        .target(
            name: "WhenThen-sdk-api",
            dependencies: []
        ),
        .target(name: "WhenThen-Intent")
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
