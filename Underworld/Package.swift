// swift-tools-version:5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Underworld",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "Kit",
      targets: ["Kit"]),
    .library(
      name: "Alne",
      targets: ["Alne"]),
    .library(
      name: "Database",
      targets: ["Database"]),
    .library(
      name: "Domain",
      targets: ["Domain"]),
    .library(
      name: "Persistence",
      targets: ["Persistence"]),
    .library(
      name: "Charts",
      targets: ["Charts"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "Kit",
      dependencies: []),
    .target(
      name: "Alne",
      dependencies: []),
    .target(
      name: "Database",
      dependencies: [],
      resources: [.copy("Resources/Alfheim.xcdatamodeld")]),
    .target(
      name: "Domain",
      dependencies: []),
    .target(
      name: "Persistence",
      dependencies: [
        "Kit",
        "Alne",
        "Database",
        "Domain",
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "Charts",
      dependencies: []),
    .testTarget(
      name: "DatabaseTests",
      dependencies: ["Database"]),
    .testTarget(
      name: "DomainTests",
      dependencies: ["Domain"]),
  ]
)
