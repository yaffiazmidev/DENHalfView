// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DENHalfView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DENHalfView",
            targets: ["DENHalfView"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DENHalfView")
    ],
    
    swiftLanguageVersions: [.v5]
)
