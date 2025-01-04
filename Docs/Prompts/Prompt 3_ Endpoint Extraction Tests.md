# Prompt 3: Endpoint Extraction Tests

## Goal
Set up tests to validate endpoint extraction based on the provided example files (`Server.swift`, `Types.swift`, and `openapi.yaml`). Ensure tests cover workflows, runs, logs, and API behavior.

---

## Execution

### Step 1: Add Example Files to Project
1. Place the provided files in the repository under the following structure:
```
OpenAPIHandlerGen/
├── Tests/
│   ├── Resources/
│   │   ├── Server.swift
│   │   ├── Types.swift
│   │   └── openapi.yaml
│   ├── EndpointExtractionTests.swift
```
2. Confirm files are properly tracked by Git:
```bash
git add Tests/Resources/Server.swift Tests/Resources/Types.swift Tests/Resources/openapi.yaml
```

### Step 2: Update `Package.swift`
Add dependencies and resources:
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OpenAPIHandlerGen",
    platforms: [
        .macOS(.v12) // Specify macOS version for local development
    ],
    dependencies: [
        // Add the Yams dependency for parsing YAML
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0"),
        // Add OpenAPIRuntime dependency
        .package(url: "https://github.com/Apodini/OpenAPIRuntime.git", from: "0.1.0")
    ],
    targets: [
        .executableTarget(
            name: "OpenAPIHandlerGen",
            dependencies: [
                .product(name: "Yams", package: "Yams"),
                .product(name: "OpenAPIRuntime", package: "OpenAPIRuntime")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "OpenAPIHandlerGenTests",
            dependencies: [
                "OpenAPIHandlerGen",
                .product(name: "OpenAPIRuntime", package: "OpenAPIRuntime")
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
```

### Step 3: Write Test Cases
Create `EndpointExtractionTests.swift` under `Tests` directory:
```swift
import XCTest
@testable import OpenAPIHandlerGen

final class EndpointExtractionTests: XCTestCase {

    func loadResource(named name: String, type: String) throws -> String {
        let path = Bundle.module.path(forResource: name, ofType: type)!
        return try String(contentsOfFile: path)
    }

    func testListWorkflowsEndpoint() throws {
        let server = try loadResource(named: "Server", type: "swift")
        let types = try loadResource(named: "Types", type: "swift")
        let openapi = try loadResource(named: "openapi", type: "yaml")

        let api = APIProtocol(server: server, types: types, openapi: openapi)
        let result = api.listWorkflows()
        XCTAssertNotNil(result, "List Workflows endpoint failed")
    }

    func testGetWorkflowEndpoint() throws {
        let server = try loadResource(named: "Server", type: "swift")
        let types = try loadResource(named: "Types", type: "swift")
        let openapi = try loadResource(named: "openapi", type: "yaml")

        let api = APIProtocol(server: server, types: types, openapi: openapi)
        let result = api.getWorkflow(id: "123")
        XCTAssertNotNil(result, "Get Workflow endpoint failed")
    }

    func testListWorkflowRunsEndpoint() throws {
        let server = try loadResource(named: "Server", type: "swift")
        let types = try loadResource(named: "Types", type: "swift")
        let openapi = try loadResource(named: "openapi", type: "yaml")

        let api = APIProtocol(server: server, types: types, openapi: openapi)
        let result = api.listWorkflowRuns(workflowId: "123")
        XCTAssertNotNil(result, "List Workflow Runs endpoint failed")
    }

    func testDownloadWorkflowLogsEndpoint() throws {
        let server = try loadResource(named: "Server", type: "swift")
        let types = try loadResource(named: "Types", type: "swift")
        let openapi = try loadResource(named: "openapi", type: "yaml")

        let api = APIProtocol(server: server, types: types, openapi: openapi)
        let result = api.downloadWorkflowLogs(runId: "456")
        XCTAssertNotNil(result, "Download Logs endpoint failed")
    }
}
```

### Step 4: Local Testing Configuration

#### 1. Setting Up Local Testing Environment
Ensure your system has:
- Swift 5.7+ installed.
- Git access to your repository.

#### 2. Create Local Logs Directory
```bash
mkdir -p TestLogs
```

#### 3. Run Tests Locally
```bash
cd OpenAPIHandlerGen
swift build
swift test > ../TestLogs/test-results.log
```

#### 4. Validate Logs Output
```bash
ls TestLogs/
cat TestLogs/test-results.log
```

#### 5. Script for Repeatable Testing
Save this as `run-tests.sh` in the root directory:
```bash
#!/bin/bash
set -e

# Create Logs Directory
mkdir -p TestLogs

# Build and Test
cd OpenAPIHandlerGen
swift build
swift test > ../TestLogs/test-results.log

# Display Logs
echo "Test results:"
cat ../TestLogs/test-results.log
```

Make it executable:
```bash
chmod +x run-tests.sh
```

---

## Conclusion
This document resolves prior issues with the `Package.swift` file and integrates automated tests for endpoint extraction. It also supports switching to local testing with a script for managing logs effectively.

