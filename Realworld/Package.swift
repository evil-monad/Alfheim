// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Realworld",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Components",
            targets: ["Components"]),
        .library(
            name: "Features",
            targets: ["Features"]),
    ],
    dependencies: [
        .package(path: "../Underworld"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Components",
            dependencies: [
                .product(name: "Alne", package: "Underworld"),
                .product(name: "Kit", package: "Underworld"),
            ]
        ),
        .target(
            name: "Features",
            dependencies: [
                .product(name: "Alne", package: "Underworld"),
                .product(name: "Kit", package: "Underworld"),
                .product(name: "Domain", package: "Underworld"),
                .product(name: "Persistence", package: "Underworld"),
                .product(name: "Charts", package: "Underworld"),
                "Components",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
    ]
)
