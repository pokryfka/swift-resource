// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Resource",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "Resource",
            targets: ["Resource"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Resource",
            dependencies: []
        ),
    ]
)
