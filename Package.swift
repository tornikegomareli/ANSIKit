// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ANSIKit",
    platforms: [.macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ANSIKit",
            targets: ["ANSIKit"]),
    ],
    targets: [
        .target(
            name: "ANSIKit"
        ),
        .testTarget(
            name: "ANSIKitTests",
            dependencies: ["ANSIKit"]),
    ]
)
