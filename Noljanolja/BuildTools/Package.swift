// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.8"),
        .package(url: "https://github.com/SwiftGen/SwiftGen", from: "6.6.2")
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
