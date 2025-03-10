// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWMessageBar",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWMessageBar", targets: ["WWMessageBar"]),
    ],
    targets: [
        .target(name: "WWMessageBar", resources: [.process("Storyboard"), .process("Material/Media.xcassets"), .copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
