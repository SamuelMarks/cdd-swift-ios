// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cdd-swift",
    dependencies: [
        // .package(url: "https://github.com/yanagiba/swift-ast.git", from: "0.18.10")
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.3.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50000.0")),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "cdd-swift",
            dependencies: ["Utility", "SwiftSyntax", "Yams"]),
    ]
)
