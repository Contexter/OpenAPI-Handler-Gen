// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OpenAPIHandlerGen",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "OpenAPIHandlerGen",
            targets: ["OpenAPIHandlerGen"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "OpenAPIHandlerGen",
            dependencies: ["Yams"],
            path: "Sources"
        ),
        .testTarget(
            name: "OpenAPIHandlerGenTests",
            dependencies: ["OpenAPIHandlerGen"],
            path: "Tests"
        )
    ]
)
