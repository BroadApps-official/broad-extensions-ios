// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BroadExtensions",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "BroadExtensions", targets: ["BroadExtensions"])
    ],
    targets: [
        .target(name: "BroadExtensions")
    ],
    swiftLanguageModes: [.v5]
)
