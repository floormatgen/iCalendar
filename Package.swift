// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iCalendar",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v5),
        .tvOS(.v13),
        .visionOS(.v1),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iCalendar",
            targets: ["iCalendar"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing.git", from: "0.14.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "iCalendar",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing"),
            ]
        ),
        .testTarget(
            name: "iCalendarTests",
            dependencies: ["iCalendar"]
        ),
    ]
)
