// swift-tools-version: 6.0.3
import PackageDescription

let package = Package(
    name: "OpenAPIHandlerGen",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "OpenAPIHandlerGen", targets: ["OpenAPIHandlerGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.6"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "OpenAPIHandlerGen",
            dependencies: [
                "Yams",
                .product(name: "Vapor", package: "vapor") // Correct dependency declaration
            ]
        ),
        .testTarget(
            name: "OpenAPIHandlerGenTests",
            dependencies: ["OpenAPIHandlerGen"]
        )
    ]
)
