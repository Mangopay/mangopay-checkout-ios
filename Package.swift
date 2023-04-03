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
            targets: ["MangoPayIntent"]),
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
            name: "MangoPayCoreiOS",
            dependencies: [
                "MangoPaySdkAPI",
<<<<<<< HEAD
//                .targetItem(name: "MangoPaySdkAPI", condition: .when(platforms: [.iOS]))
=======
>>>>>>> ci-config
            ],
            resources: [
                .copy("Resources/countrylistdata.json"),
                .process("Resources/Images")
            ]
        ),
        .target(
            name: "MangoPaySdkAPI",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .target(
            name: "MangoPayIntent",
            dependencies: [
                "MangoPaySdkAPI",
            ]
        ),
        .target(
            name: "MangoPayVault",
            dependencies: [
                "MangoPaySdkAPI",
                "MangoPayCoreiOS"
            ]
        ),
        .binaryTarget(
            name: "NethoneSDK",
            path: "Integrations/NethoneSDK.xcframework"
        ),
<<<<<<< HEAD
        .testTarget(
            name: "Tests",
            dependencies: [
                "MangoPayVault",
                "MangoPaySdkAPI",
                "MangoPayCoreiOS"
            ],
            path: "Tests"
//            swiftSettings: [
//                .unsafeFlags(["-enable-testing-search-paths"]),
//            ]
        )
=======
    
//        .testTarget(
//            name: "checkout-ios-sdkTests",
//            dependencies: ["checkout-ios-sdk"]),
>>>>>>> ci-config
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
