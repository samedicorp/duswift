// swift-tools-version:5.2

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/05/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "duswift",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
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
                .product(name: "Coercion", package: "Coercion")
            ]
        ),
        .testTarget(
            name: "duswiftTests",
            dependencies: ["duswift", "XCTestExtensions"]),
    ]
)
