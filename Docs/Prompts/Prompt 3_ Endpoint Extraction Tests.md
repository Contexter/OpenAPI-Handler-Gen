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

### Step 2: Write Test Cases
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

### Step 3: Update CI/CD Pipeline for Tests
Modify the GitHub Actions pipeline to include new tests:

#### Workflow File Update
```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Set up Swift
        uses: swift-actions/setup-swift@v1
        with:
          swift-version: "5.7"

      - name: Run Tests
        run: |
          cd OpenAPIHandlerGen
          swift test

      - name: Upload Test Logs
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: Tests/Resources/*
```

---

## Next Steps
- Validate CI/CD pipeline executes tests successfully.
- Monitor failures and add additional test cases as needed.
- Integrate logs and debugging tools to trace test failures.

---

## Commit Reference
This implementation updates **Prompt 3** with endpoint extraction tests based on the example files provided.

```bash
git add Tests/EndpointExtractionTests.swift

git commit -m "test: Add endpoint extraction tests using provided examples. References #13."

git push
```

---

## Conclusion
This prompt focuses on adding automated tests for validating endpoint extraction, integrating the provided example files into the project structure, and ensuring compatibility with the CI/CD pipeline.

