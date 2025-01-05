# OpenAPIHandlerGen - CLI Tool for OpenAPI Handler and Service Generation

## Overview
**OpenAPIHandlerGen** is a Swift command-line tool (CLI) designed to parse an **OpenAPI YAML** file, a Swift **server-protocol** file, and a Swift **types** file to generate **Handler** and **Service** Swift files. 

- **Handler Files**: Provide route handling logic.
- **Service Files**: Provide business logic implementation.

This tool enables faster development of **Vapor-based APIs** by generating reusable code structures for endpoint handling.

---

## 1. Project Structure

### Current Project Layout:
```
OpenAPIHandlerGen/
├── Package.swift
├── README.md
├── Sources/
│   ├── Core/
│   │   ├── OpenAPIHandlerGen.swift
│   ├── Parsers/
│   │   ├── YAMLParser.swift
│   ├── Extractors/
│   │   ├── EndpointExtractor.swift
│   ├── Generators/
│   │   ├── HandlerGenerator.swift
│   │   ├── ServiceGenerator.swift
│   ├── main.swift
├── Tests/
│   ├── EndpointExtractionTests.swift
│   ├── InlineCodeTests.swift
├── Docs/
│   ├── Prompt 6 - Modularization Strategy for OpenAPIHandlerGen.md
├── TestLogs/
│   ├── test-results.log
├── Scripts/
│   ├── build_and_test.sh
```

---

## 2. Dependencies and Setup

### Dependencies
- **Yams**: YAML parsing.
- **Vapor**: HTTP server framework.

### `Package.swift` Configuration:
```swift
// swift-tools-version: 6.0.3
import PackageDescription

let package = Package(
    name: "OpenAPIHandlerGen",
    platforms: [
        .macOS(.v12)
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
                .product(name: "Vapor", package: "vapor")
            ]
        ),
        .testTarget(
            name: "OpenAPIHandlerGenTests",
            dependencies: ["OpenAPIHandlerGen"]
        )
    ]
)
```

### Install Dependencies:
```bash
swift package update
swift package resolve
```

---

## 3. Building and Testing

### Build:
```bash
swift build
```

### Test:
```bash
swift test
```

---

## 4. Running the Tool

### Example Command:
```bash
.build/debug/OpenAPIHandlerGen \
    /path/to/openapi.yaml \
    /path/to/Server.swift \
    /path/to/Types.swift \
    GeneratedOutput
```
- **Arguments**:
  1. `<openapi.yaml>`: Path to the OpenAPI YAML file.
  2. `<Server.swift>`: Path to the Swift file defining protocol methods.
  3. `<Types.swift>`: Path to Swift file with type definitions.
  4. `<outputPath>`: Output directory for generated files.

- **Output Structure**:
```
GeneratedOutput/
├── Handlers/
│   ├── GetUsersHandler.swift
├── Services/
│   ├── GetUsersService.swift
```

---

## 5. Generated Code Examples

### Handler Example:
```swift
// File: Sources/Generators/Handlers/GetUsersHandler.swift
import Vapor

struct GetUsersHandler: APIProtocol {
    let service = GetUsersService()

    func getUsers(_ input: Operations.GetUsers.Input) async throws -> Operations.GetUsers.Output {
        let result = try await service.execute(input: input)
        return .ok(result)
    }
}
```

### Service Example:
```swift
// File: Sources/Generators/Services/GetUsersService.swift
import Vapor

struct GetUsersService {
    func execute(input: Operations.GetUsers.Input) async throws -> Operations.GetUsers.Output {
        // TODO: Implement business logic.
        return .init()
    }
}
```

---

## 6. CI/CD Pipeline
- Tests automatically execute via GitHub Actions.
- Ensure CI/CD checks pass before merging changes.

---

## Conclusion
The **OpenAPIHandlerGen** CLI simplifies the process of generating code templates for Vapor endpoints based on OpenAPI specifications. Use this tool to bootstrap projects quickly and enforce consistent coding standards across your codebase.

