// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoviesFeature",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MoviesFeature",
            targets: ["MoviesFeature"]),
    ],
    dependencies: [
      .package(url: "Dependencies", from: "1.0.0"),
      .package(url: "UIComponents", from: "1.0.0"),
      .package(url: "Utilities", from: "1.0.0"),
      .package(url: "Storage", from: "1.0.0"),
      .package(url: "Core", from: "1.0.0"),
      .package(url: "Reviews", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MoviesFeature",
            dependencies: [
              .byName(name: "Dependencies"),
              .byName(name: "UIComponents"),
              .byName(name: "Utilities"),
              .byName(name: "Storage"),
              .byName(name: "Core"),
              .byName(name: "Reviews"),
            ]
        ),
        .testTarget(
            name: "MoviesFeatureTests",
            dependencies: ["MoviesFeature"]),
    ]
)
