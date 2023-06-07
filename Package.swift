// swift-tools-version:5.5
import PackageDescription

let name = "VeraSDK"
let version = "0.1.22"

let package = Package(
    name: name,
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: name,
            targets: [name]
        )
    ],
    targets: [
        .binaryTarget(
            name: name,
            path: "VeraSDK.xcframework"
        )
    ]
)
