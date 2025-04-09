// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import Foundation
import PackageDescription

let package = Package(
    name: "MovieDBDependencies",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MovieDBDependencies",
            targets: ["MovieDBDependencies"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MovieDBDependencies"),
        .testTarget(
            name: "MovieDBDependenciesTests",
            dependencies: ["MovieDBDependencies"]),
    ]
)
//
//let package = Package(
//  name: "MovieDBDependencies",
//  defaultLocalization: "en",
//  platforms: [.iOS(.v17)],
//  products: _Package.Module.allCases.map(\.product),
//  dependencies: _Package.PackageDependency.allCases.map(\.packageDependency),
//  targets: _Package.Module.allCases.flatMap(\.targets)
//)
//
//// MARK: Modules
//
//extension _Package.Module: CaseIterable {
//  static let allCases: [Self] = [
//    
//  ]
//}
//
//// MARK: External dependency
//extension _Package.PackageDependency {}
//
//// MARK: List of all external dependencies
//extension _Package.PackageDependency: CaseIterable {
//  static let allCases: [Self] = [
//    
//  ] + baseDependencies
//}
//
//// MARK: Plugin dependency definitions
///// Plugin dependencies which are specific to this package.
//extension _Package.PluginDependency  {}
//
//enum _Package {
//  enum PackageDependency {
//    case local(Local)
//    case remote(Remote)
//    
//    struct Local {
//      let name: String
//      let path: String
//    }
//    
//    struct Remote {
//      let name: String
//      let url: String
//      let versionType:  VersionType
//      
//      enum VersionType {
//        case from(Version)
//        case range(Range<Version>)
//        case closedRange(ClosedRange<Version>)
//        case branch(String)
//        case revision(String)
//        case exact(Version)
//      }
//    }
//  }
//  
//  enum TargetDependency {
//    case `internal`(String)
//    case external(External)
//    
//    struct External {
//      let product: String
//      let package: PackageDependency
//    }
//  }
//  
//  struct PluginDependency {
//    let product: String
//    let package: PackageDependency
//  }
//  
//  struct Module {
//    let name: String
//    let hasTests: Bool
//    let isExecutable: Bool
//    let targetDependencies: [TargetDependency]
//    let testTargetDependencies: [TargetDependency]
//    let resources: [Resource]?
//    let pluginDependencies: [PluginDependency]
//    let testTargetPluginDependencies: [PluginDependency]
//    let targetSwiftSettings: [SwiftSetting]
//    let testTargetSwiftSettings: [SwiftSetting]
//    
//    init(
//      name: String,
//      hasTests: Bool = true,
//      isExecutable: Bool = false,
//      targetDependencies: [TargetDependency] = [],
//      testTargetDependencies: [TargetDependency] = [],
//      resources: [Resource]? = nil,
//      pluginDependencies: [PluginDependency] = [],
//      testTargetPluginDependencies: [PluginDependency] = [],
//      targetSwiftSettings: [SwiftSetting] = Self.defaultTargetSwiftSettings,
//      testTargetSwiftSettings: [SwiftSetting] = Self.defaultTestTargetSwiftSettings
//    ) {
//      self.name = name
//      self.hasTests = hasTests
//      self.isExecutable = isExecutable
//      self.targetDependencies = targetDependencies
//      self.testTargetDependencies = testTargetDependencies
//      self.resources = resources
//      self.pluginDependencies = pluginDependencies
//      self.testTargetPluginDependencies = testTargetPluginDependencies
//      self.targetSwiftSettings = targetSwiftSettings
//      self.testTargetSwiftSettings = testTargetSwiftSettings
//    }
//  }
//}
//
///// This should contain the external package dependencies that EVERY package will see.
//extension _Package.PackageDependency {
//  static let baseDependencies: [Self] = []
//}
//
//extension _Package.PackageDependency {
//  var packageDependency: Package.Dependency {
//    switch self {
//    case .local(let local):
//      return .package(name: local.name, path: local.path)
//    case .remote(let remote):
//      return remote.packageDependency
//    }
//  }
//  
//  var name: String {
//    switch self {
//    case .local(let local):
//      return local.name
//    case .remote(let remote):
//      return remote.name
//    }
//  }
//}
//
//extension _Package.PackageDependency.Remote {
//  var packageDependency: Package.Dependency {
//    switch versionType {
//    case .from(let version):
//      return .package(url: url, from: version)
//    case .range(let range):
//      return .package(url: url, range)
//    case .closedRange(let closedRange):
//      return .package(url: url, closedRange)
//    case .branch(let branch):
//      return .package(url: url, branch: branch)
//    case .revision(let revision):
//      return .package(url: url, revision: revision)
//    case .exact(let version):
//      return .package(url: url, exact: version)
//    }
//  }
//}
//
///// This extension should contain the plugin dependencies which EVERY package will use
//extension _Package.PluginDependency {}
//
//extension _Package.PluginDependency {
//  var asTargetPluginUsage: Target.PluginUsage {
//    .plugin(name: product, package: package.name)
//  }
//}
//
//extension _Package.TargetDependency {
//  var asTargetDependency: Target.Dependency {
//    switch self {
//    case .internal(let name):
//      return .target(name: name)
//    case .external(let external):
//      return .product(name: external.product, package: external.package.name)
//    }
//  }
//}
//
//extension SwiftSetting {
//  // static let warningAsErrors: Self = .unsafeFlags(["-warnings-as-errors"])
//}
//
//extension _Package.Module {
//  static let defaultTargetSwiftSettings: [SwiftSetting] = [
//    // .warningAsErrors,
//  ] // + Self.environmentSwiftSettings
//  static let defaultTestTargetSwiftSettings: [SwiftSetting] = [
//    // .warningAsErrors,
//  ] // + Self.environmentSwiftSettings
//  
//  private static let defaultTargetPlugins: [_Package.PluginDependency] = []
//  private static let defaultTestTargetPlugins: [_Package.PluginDependency] = []
//  
//  var productName: String { name }
//  var targetName: String { name }
//  var testTargetName: String { name + "Tests" }
//  
//  var product: Product {
//    isExecutable
//      ? .executable(name: productName, targets: [targetName])
//      : .library(name: productName, targets: [targetName])
//  }
//  
//  var asTargetDependency: Target.Dependency {
//    .target(name: targetName)
//  }
//  
//  var libraryTarget: Target {
//    .target(
//      name: targetName,
//      dependencies: targetDependencies.map(\.asTargetDependency),
//      resources: resources,
//      swiftSettings: targetSwiftSettings,
//      plugins: allTargetPlugins.map(\.asTargetPluginUsage)
//    )
//  }
//  
//  var testTarget: Target? {
//    guard hasTests else { return nil }
//    return .testTarget(
//      name: testTargetName,
//      dependencies: [asTargetDependency] + testTargetDependencies.map(\.asTargetDependency),
//      swiftSettings: testTargetSwiftSettings,
//      plugins: allTestTargetPlugins.map(\.asTargetPluginUsage)
//    )
//  }
//  
//  var targets: [Target] {
//    [libraryTarget, testTarget].compactMap { $0 }
//  }
//  
//  var allTargetPlugins: [_Package.PluginDependency] {
//    Self.defaultTargetPlugins + pluginDependencies
//  }
//  
//  var allTestTargetPlugins: [_Package.PluginDependency] {
//    Self.defaultTestTargetPlugins + testTargetPluginDependencies
//  }
//  
//  private static func swiftSettings(for environmentKey: String, buildConfiguration: BuildConfiguration?) -> [SwiftSetting] {
//    guard let environmentValue = Context.environment[environmentKey], !environmentKey.isEmpty else {
//      return []
//    }
//    
//    let condition: BuildSettingCondition? = buildConfiguration.map { .when(configuration: $0) }
//    return environmentValue
//      .split(separator: ",")
//      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//      .map { SwiftSetting.define($0, condition) }
//  }
//}
