// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "device_unique_id",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "device_unique_id", targets: ["device_unique_id"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "device_unique_id",
            dependencies: [],
            path: "Classes",
            resources: []
        )
    ]
)
