// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "OpenGoogleSignInSDK",
    platforms: [
        .iOS(.v12),
        .macOS("10.9")
    ],
    products: [
        .library(
            name: "OpenGoogleSignInSDK",
            targets: ["OpenGoogleSignInSDK"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "OpenGoogleSignInSDK",
            dependencies: []
        ),
        .testTarget(
            name: "OpenGoogleSignInSDKTests",
            dependencies: ["OpenGoogleSignInSDK"]
        ),
    ]
)
