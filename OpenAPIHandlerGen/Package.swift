// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OpenAPIHandlerGen",
    platforms: [
        .macOS(.v12) // Specify macOS version for local development
    ],
    dependencies: [
        // Add the Yams dependency for parsing YAML
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
            path: "Tests",
            resources: [
                .copy("Resources/Server.swift"),
                .copy("Resources/Types.swift"),
                .copy("Resources/openapi.yaml")
            ]
        )
    ]
)
