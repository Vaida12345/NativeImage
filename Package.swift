// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NativeImage",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16)
    ], products: [
        .library(name: "NativeImage", targets: ["NativeImage"]),
    ], dependencies: [
        .package(url: "https://github.com/Vaida12345/FinderItem", from: "1.0.0")
    ], targets: [
        .target(name: "NativeImage", dependencies: ["FinderItem"], path: "Sources"),
        .testTarget(name: "Tests", dependencies: ["NativeImage"], path: "Tests")
    ], swiftLanguageModes: [.v6]
)
