// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZoomableImage",
    platforms: [
      .iOS(.v17),
      .macOS(.v14),
    ],
    products: [
        .library(
            name: "ZoomableImage",
            targets: ["ZoomableImage"]),
    ],
    targets: [
        .target(
            name: "ZoomableImage"),

    ]
)
