// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OpenAPIHandlerGen",
    platforms: [
        .macOS(.v12) // Specify macOS 12 or later
    ],
    dependencies: [
        // Add the Yams dependency for parsing YAML
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            // Target name matches the executable name
            name: "OpenAPIHandlerGen",
            dependencies: [
                .product(name: "Yams", package: "Yams")
            ],
            // Point to the root "Sources" folder as it directly contains "main.swift"
            path: "Sources"
        )
    ]
)
