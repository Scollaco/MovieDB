// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Details",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Details",
            targets: ["Details"]),
    ],
    dependencies: [
      .package(url: "MovieDBDependencies", from: "1.0.0"),
      .package(url: "UIComponents", from: "1.0.0"),
      .package(url: "Reviews", from: "1.0.0"),
      .package(url: "Storage", from: "1.0.0"),
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.18.0"),
      .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.8.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Details",
            dependencies: [
              .byName(name: "MovieDBDependencies"),
              .byName(name: "UIComponents"),
              .byName(name: "Reviews"),
              .byName(name: "Storage"),
              .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
              .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "DetailsTests",
            dependencies: ["Details"]),
    ]
)
