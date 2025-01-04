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

### Step 4: CI/CD Pipeline Validation
The pipeline automatically detects new test cases added under the `Tests` directory and processes all files, including those in `Tests/Resources/`. Artifacts are uploaded for logs and debugging purposes.

#### Full CI/CD Pipeline
```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

permissions:
  contents: write

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v3

    - name: Set up Swift
      uses: swift-actions/setup-swift@v1
      with:
        swift-version: '5.7'

    - name: Prepare Test Logs Directory
      run: |
        mkdir -p TestLogs

    - name: Resolve Dependencies
      run: swift package resolve

    - name: Build and Test
      run: |
        cd OpenAPIHandlerGen
        swift build
        swift test > ../TestLogs/test-results.log

    - name: Upload Test Logs
      uses: actions/upload-artifact@v3
      with:
        name: test-results
        path: Tests/Resources/*

    - name: Debug Directory Structure
      run: |
        pwd
        ls -R

    - name: Commit Test Logs to Repo
      run: |
        git config --global user.name 'github-actions[bot]'
        git config --global user.email 'github-actions[bot]@users.noreply.github.com'
        git add TestLogs/test-results.log
        git commit -m "ci: Add test results log [skip ci]" || echo "No changes to commit"
        git push
```

---

## Conclusion
This prompt resolves prior issues with the `Package.swift` file and integrates automated tests for endpoint extraction while ensuring compatibility with the CI/CD pipeline.

