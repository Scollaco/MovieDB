// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SearchFeature",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SearchFeature",
            targets: ["SearchFeature"]),
    ],
    dependencies: [
      .package(url: "MovieDBDependencies", from: "1.0.0"),
      .package(url: "UIComponents", from: "1.0.0"),
      .package(url: "Routing", from: "1.0.0"),
      .package(url: "MoviesFeature", from: "1.0.0"),
      .package(url: "SeriesFeature", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SearchFeature",
            dependencies: [
              .byName(name: "MovieDBDependencies"),
              .byName(name: "UIComponents"),
              .byName(name: "Routing"),
              .byName(name: "MoviesFeature"),
              .byName(name: "SeriesFeature"),
            ]
        ),
        .testTarget(
            name: "SearchFeatureTests",
            dependencies: ["SearchFeature"]),
    ]
)
