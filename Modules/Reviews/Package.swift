// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reviews",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Reviews",
            targets: ["Reviews"]),
    ],
    dependencies: [
      .package(url: "Networking", from: "1.0.0"),
      .package(url: "MovieDBDependencies", from: "1.0.0"),
      .package(url: "UIComponents", from: "1.0.0"),
      .package(url: "Utilities", from: "1.0.0"),
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.18.0"),
      .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.8.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Reviews",
            dependencies: [
              .byName(name: "Networking"),
              .byName(name: "MovieDBDependencies"),
              .byName(name: "UIComponents"),
              .byName(name: "Utilities"),
              .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
              .product(name: "Dependencies", package: "swift-dependencies"),
            ]
          ),
        .testTarget(
            name: "ReviewsTests",
            dependencies: ["Reviews"]),
    ]
)
