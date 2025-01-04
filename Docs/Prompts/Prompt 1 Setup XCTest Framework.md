# Prompt 1 Setup XCTest Framework

## Goal
Integrate XCTest into the project and create an initial test structure, including a functional YAML parsing validation test.

---

## Execution

### Step 1: Create Test Directory
- Directory Path: `OpenAPIHandlerGen/Tests`
- Purpose: Organize all test cases under the central `Tests` folder, aligned with the project tree.

### Step 2: Add Test File
- File Name: `YAMLParsingTests.swift`
- Location: `OpenAPIHandlerGen/Tests/YAMLParsingTests.swift`
- Purpose: Implement YAML parsing tests directly under the unified `Tests` directory.

### Step 3: Implement YAML Parsing Tests

```swift
import XCTest
@testable import OpenAPIHandlerGen

final class YAMLParsingTests: XCTestCase {

    func testValidYAMLParsing() throws {
        let validYAML = """
        openapi: 3.0.0
        info:
          title: Test API
          version: 1.0.0
        """
        
        let parser = YAMLParser()
        XCTAssertNoThrow(try parser.parse(validYAML))
    }

    func testInvalidYAMLParsing() throws {
        let invalidYAML = """
        openapi: 3.0.0
        info: [title: Test API]
        """
        
        let parser = YAMLParser()
        XCTAssertThrowsError(try parser.parse(invalidYAML))
    }
}
```

### Step 4: Verify XCTest Execution
- Navigate to the root directory of the project (`OpenAPIHandlerGen`).
- Run tests using the following command:
```
swift test
```

---

## Configure Package.swift
Ensure that the `Package.swift` file is updated to include dependencies and recognize test targets.

```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OpenAPIHandlerGen",
    platforms: [
        .macOS(.v12), // For local development
        .linux // Add support for Linux-based CI/CD runners
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
```
---

## Next Steps
- Expand parsing tests to include edge cases (empty YAML, nested structures, etc.).
- Prepare CI/CD pipeline for automated test execution.

---

## Commit Reference
This implementation addresses **Prompt 1** and prepares the foundation for further testing enhancements as outlined in **Issue #13**.

```bash
git add Docs/Prompts/Prompt\ 1\ Setup\ XCTest\ Framework.md

git commit -m "docs(prompts): Add Prompt 1 XCTest setup with YAML parsing validation tests and updated Package.swift for CI/CD compatibility. References #13."

git push
```

---

## Conclusion
This prompt establishes the initial test framework using XCTest and provides functional YAML parsing validation, serving as the foundation for broader test coverage in subsequent prompts.

