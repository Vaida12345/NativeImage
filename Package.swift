// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphicsKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16)
    ], products: [
        .library(name: "GraphicsKit", targets: ["GraphicsKit"]),
    ], dependencies: [
        .package(name: "FinderItem",
                 path: "~/Library/Mobile Documents/com~apple~CloudDocs/DataBase/Projects/Packages/FinderItem")
    ], targets: [
        .target(name: "GraphicsKit", dependencies: ["FinderItem"]),
        .testTarget(name: "GraphicsKitTests", dependencies: ["GraphicsKit"])
    ], swiftLanguageModes: [.v5]
)
