// swift-tools-version:5.5
import PackageDescription

let name = "VeraSDK"
let version = "1.0.1"

let veraBinaryTarget = Target.binaryTarget(
    name: "VeraSDK",
    // path: "\(name).xcframework"
    url: "https://github.com/s2dentik/vera-ios-sdk/releases/download/v\(version)/\(name).xcframework.zip",
    checksum: "267dde0b3b35456b98480a0012bacc3e835fde48855d181334c6c463bdba504b"
)

//veraBinaryTarget.linkerSettings = [
//    .linkedFramework("GRPC")
//]

let package = Package(
    name: name,
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "VeraSDK",
//            type: .dynamic,
            targets: ["VeraSDK"]
        )
    ],
//    dependencies: [
//        .package(name: "grpc-swift", url: "https://github.com/grpc/grpc-swift.git", .upToNextMajor(from: "1.7.0")),
//        .package(name: "swift-nio", url: "https://github.com/apple/swift-nio.git", .upToNextMajor(from: "2.20.0"))
//    ],
    targets: [
//        .target(
//            name: "VeraSDKWrapper",
//            dependencies: [
//                .product(name: "NIO", package: "swift-nio"),
//                .product(name: "NIOHTTP1", package: "swift-nio"),
////                .product(name: "NIOConcurrencyHelpers", package: "swift-nio"),
//                .product(name: "GRPC", package: "grpc-swift"),
//                .target(name: "VeraSDK")
//            ],
//            path: "VeraSDKWrapper"
//        ),
        veraBinaryTarget
    ]
)
