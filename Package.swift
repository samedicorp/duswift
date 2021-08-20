// swift-tools-version:5.5

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/05/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "duswift",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .executable(
            name: "dulog",
            targets: ["dulog"]
        ),
        
            .library(
                name: "duswift",
                targets: ["duswift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/Coercion.git", from: "1.1.2"),
        .package(url: "https://github.com/elegantchaos/ElegantStrings.git", from: "1.0.2"),
        .package(url: "https://github.com/elegantchaos/Files.git", from: "1.2.0"),
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.4.2")
    ],
    targets: [
        .target(
            name: "dulog",
            dependencies: [
                "duswift",
                .product(name: "Files", package: "Files")
            ]
        ),
        .target(
            name: "duswift",
            dependencies: [
                .product(name: "Coercion", package: "Coercion"),
                .product(name: "ElegantStrings", package: "ElegantStrings"),
                .product(name: "Files", package: "Files")
            ],
            resources: [
                .copy("Resources/Examples")
            ]
        ),
        .testTarget(
            name: "duswiftTests",
            dependencies: ["duswift", "XCTestExtensions"]),
    ]
)
