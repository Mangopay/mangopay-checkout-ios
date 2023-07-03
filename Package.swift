// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MangoPayiOSSDK",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MangoPayCoreiOS",
            targets: ["MangoPayCoreiOS", "NethoneSDK"]),
        .library(
            name: "MangoPaySdkAPI",
            targets: ["MangoPaySdkAPI"]),
        .library(
            name: "MangoPayIntent",
            targets: ["MangoPayIntent"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            .upToNextMinor(from: "1.0.5")
        ),
        .package(
            url: "https://github.com/Mangopay/mangopay-ios-vault-sdk",
            .branch("main")
        ),
    ],
    targets: [
        .target(
            name: "MangoPayCoreiOS",
            dependencies: [
                "MangoPaySdkAPI",
                .product(name: "MangopayVault", package: "mangopay-ios-vault-sdk"),
            ],
            path: "MangoPayCoreiOS",
            resources: [
                .copy("Resources/countrylistdata.json"),
                .process("Resources/Images")
            ]
        ),
        .target(
            name: "MangoPaySdkAPI",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ],
            path: "MangoPaySdkAPI"
        ),
        .target(
            name: "MangoPayIntent",
            dependencies: [
                "MangoPaySdkAPI",
            ],
            path: "MangoPayIntent"
        ),
        .binaryTarget(
            name: "NethoneSDK",
            path: "Integrations/NethoneSDK.xcframework"
        ),
        .testTarget(
            name: "Tests",
            dependencies: [
                "MangoPaySdkAPI",
                "MangoPayCoreiOS"
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
