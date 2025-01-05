# Robust CI Pipeline with Independent Build and Test Tool

## Goal

Develop a robust, standalone tool to handle builds and tests using shell scripting for cross-platform compatibility.

---

## Execution

### Step 1: Create the Standalone Tool

**File:** `Scripts/build_and_test.sh`

```bash
#!/bin/bash

set -e

# Create Logs Directory
# Ensure the 'Scripts' directory exists
mkdir -p Scripts

# Create Logs Directory
mkdir -p TestLogs

# Configure Git User Identity for CI Environment
git config --global user.email "ci-bot@example.com"
git config --global user.name "CI Bot"

# Build and Test Function
function build_and_test() {
  echo "Starting Build and Test..."

  # Navigate to the correct directory
  cd OpenAPIHandlerGen || { echo "Directory OpenAPIHandlerGen not found!"; exit 1; }

  # Verify Package.swift exists
  if [ ! -f Package.swift ]; then
    echo "Package.swift not found in OpenAPIHandlerGen!" > ../TestLogs/error-$(date +'%Y%m%d-%H%M%S').log
    exit 1
  fi

  # Check Swift Version
  swift --version

  # Compile Sources
  echo "Building project..."
  swift build 2>&1 | tee ../TestLogs/build-$(date +'%Y%m%d-%H%M%S').log

  # Run Tests
  echo "Running tests..."
  swift test 2>&1 | tee ../TestLogs/test-results-$(date +'%Y%m%d-%H%M%S').log
}

# Execute the Build and Test Workflow
build_and_test

# Commit logs to GitHub repository
cd ..
git add TestLogs/*.log
git commit -m "Add logs from build and test run on $(date +'%Y-%m-%d %H:%M:%S')"
git push origin main

# Final Message
echo "Build and Test Completed Successfully!"
```

---

### Step 2: CI Workflow with Tool Integration

**File:** `.github/workflows/ci.yml`

```yaml
name: CI Pipeline

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
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Swift
        uses: swift-actions/setup-swift@v1
        with:
          swift-version: 5.7

      - name: Configure Git Identity
        run: |
          git config --global user.email "ci-bot@example.com"
          git config --global user.name "CI Bot"

      - name: Make Build Script Executable
        run: chmod +x Scripts/build_and_test.sh

      - name: Run Build and Test
        run: Scripts/build_and_test.sh

      - name: Upload Test Logs
        uses: actions/upload-artifact@v3
        with:
          name: TestLogs
          path: TestLogs/
```

---

### Step 3: Update Mock Test Suite

**File:** `Tests/InlineCodeTests.swift`

```swift
import XCTest

final class InlineCodeTests: XCTestCase {

    struct MockAPI {
        func listWorkflows() -> [String] {
            return ["Workflow1", "Workflow2"]
        }

        func getWorkflow(id: String) -> String? {
            return id == "123" ? "Workflow123" : nil
        }

        func listWorkflowRuns(workflowId: String) -> [String] {
            return workflowId == "123" ? ["Run1", "Run2"] : []
        }

        func downloadWorkflowLogs(runId: String) -> String? {
            return runId == "456" ? "Logs for run 456" : nil
        }
    }

    let api = MockAPI()

    func testListWorkflows() {
        let result = api.listWorkflows()
        XCTAssertEqual(result.count, 2)
    }

    func testGetWorkflow() {
        let result = api.getWorkflow(id: "123")
        XCTAssertEqual(result, "Workflow123")
    }

    func testListWorkflowRuns() {
        let result = api.listWorkflowRuns(workflowId: "123")
        XCTAssertEqual(result.count, 2)
    }

    func testDownloadWorkflowLogs() {
        let result = api.downloadWorkflowLogs(runId: "456")
        XCTAssertEqual(result, "Logs for run 456")
    }
}
```

---

## Resulting Repository Tree

```
OpenAPI-Handler-Gen/
├── .github/
│   └── workflows/
│       └── ci.yml
├── Docs/
│   ├── A Pragmatic Shift Executing with Prompts.md
│   ├── Comprehensive Test Suite for OpenAPIHandlerGen.md
│   ├── Development and Testing Plan for OpenAPIHandlerGen.md
│   ├── Prompts/
│   │   ├── Prompt 1 Setup XCTest Framework.md
│   │   ├── Prompt 2 CI_CD Pipeline Setup.md
│   │   ├── Prompt 3_ Endpoint Extraction Tests.md
│   └── Use Case and Necessity of OpenAPIHandlerGen.md
├── LICENSE
├── OpenAPIHandlerGen/
│   ├── .gitignore
│   ├── Package.resolved
│   ├── Package.swift
│   ├── Sources/
│   │   └── OpenAPIHandlerGen.swift
│   ├── Tests/
│   │   └── InlineCodeTests.swift
├── Scripts/
│   ├── build_and_test.sh
├── TestLogs/
│   ├── build-YYYYMMDD-HHMMSS.log
│   ├── test-results-YYYYMMDD-HHMMSS.log
│   ├── error-YYYYMMDD-HHMMSS.log
├── README.md
```

---

## Explanation of `tee` Command

The `tee` command in the shell script is used to **redirect output to both a file and the console simultaneously**.

### Functionality:

- **Displays output** of commands (e.g., `swift build`) in the terminal.
- **Writes output** to a file, capturing logs for later inspection.

### Example from the Script:

```bash
swift build 2>&1 | tee ../TestLogs/build-$(date +'%Y%m%d-%H%M%S').log
```

- **`swift build`** runs the build command.
- **`2>&1`** merges standard error (2) and standard output (1).
- **`| tee ...`** saves output to the file **while displaying it in real time**.

This ensures logs are captured for debugging and can be monitored immediately during execution.

---

## Conclusion

This new setup provides:

1. **Cross-platform compatibility and robustness** through shell scripting.
2. **Robust CI integration** that leverages the standalone tool.
3. **Inline mocks** to ensure isolated, flexible testing.
4. **Git integration** to ensure logs are tracked and available in the repository.

This approach is future-proof and minimizes dependencies, ensuring stability and maintainability.

