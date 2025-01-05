// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OpenAPIHandlerGen",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "OpenAPIHandlerGen",
            dependencies: [
                .product(name: "Yams", package: "Yams")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "OpenAPIHandlerGenTests",
            dependencies: [
                "OpenAPIHandlerGen"
            ],
            path: "Tests"
        )
    ]
)
