# Prompt 2 CI/CD Pipeline Setup

## Goal
Set up a CI/CD pipeline using GitHub Actions to automate test execution. Ensure compatibility with Linux runners and include steps for build, test, and reporting results.

---

## Execution

### Step 1: Create Workflow File
- File Path: `.github/workflows/ci.yml`
- Purpose: Define CI/CD workflow configuration for GitHub Actions.

### Step 2: Define Workflow Configuration
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
        swift-version: '5.7'

    - name: Build and Test
      run: |
        swift build
        swift test > TestLogs/test-results.log

    - name: Upload Test Results
      uses: actions/upload-artifact@v3
      with:
        name: test-results
        path: TestLogs/

    - name: Save Test Logs to Repository
      run: |
        mkdir -p TestLogs
        cp .build/debug/*.log TestLogs/
```

### Step 3: Create Test Logs Directory
#### Manual Setup
1. Navigate to the project directory:
   ```bash
   cd OpenAPIHandlerGen
   ```
2. Verify the project structure using:
   ```bash
   tree -L 2
   ```
   Expected structure:
   ```
   OpenAPIHandlerGen
   ├── Docs
   │   ├── A Pragmatic Shift Executing with Prompts.md
   │   ├── Comprehensive Test Suite for OpenAPIHandlerGen.md
   │   ├── Development and Testing Plan for OpenAPIHandlerGen.md
   │   ├── Use Case and Necessity of OpenAPIHandlerGen.md
   │   └── Prompts
   │       ├── Prompt 1 Setup XCTest Framework.md
   ├── LICENSE
   ├── OpenAPIHandlerGen
   │   ├── Package.resolved
   │   ├── Package.swift
   │   ├── Sources
   │   │   └── OpenAPIHandlerGen.swift
   │   ├── Tests
   │   │   ├── File.swift
   │   │   └── YAMLParsingTests.swift
   ├── README.md
   ```
3. Create the `TestLogs` directory manually at the **root level**:
   ```bash
   mkdir TestLogs
   ```
4. Ensure the directory is **tracked by Git** by adding an empty `.gitkeep` file:
   ```bash
   touch TestLogs/.gitkeep
   git add TestLogs/.gitkeep
   git commit -m "chore: Add TestLogs directory with .gitkeep file."
   ```
5. Push the changes:
   ```bash
   git push
   ```

#### CI/CD Automation
- The pipeline automatically creates the `TestLogs` directory during test execution if it does not exist.

### Step 4: Verify Workflow Execution
- Commit and push this file to the repository.
- Open the **Actions tab** in GitHub and check the workflow status.
- Confirm tests pass and outputs are logged.

---

## Next Steps
- Add test coverage reporting tools like **`codecov`** or **`coveralls`** (optional).
- Monitor test failures and integrate notifications for alerts.
- Expand CI steps to include **deployment workflows** (future prompts).

---

## Commit Reference
This implementation addresses **Prompt 2** and prepares the foundation for automated testing and CI/CD integration as outlined in **Issue #13**.

```bash
git add .github/workflows/ci.yml TestLogs/

git commit -m "ci: Add GitHub Actions workflow for CI/CD pipeline with test logs directory. References #13."

git push
```

---

## Conclusion
This prompt sets up an automated CI/CD pipeline using GitHub Actions to build and test the project, ensuring compatibility with Linux runners and enabling consistent validation during development. A dedicated `TestLogs` directory is created in the repository to store logs for external accessibility and debugging.

