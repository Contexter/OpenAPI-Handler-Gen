# Prompt 5 Endpoint Extraction Tests

## Goal
Validate endpoint extraction logic by testing path parsing, HTTP method handling, and operation ID consistency.

---

## Execution

### Step 1: Create Endpoint Tests Directory
- Directory Path: `OpenAPIHandlerGen/Tests`
- Purpose: Centralize endpoint extraction tests under the unified `Tests` directory.

### Step 2: Add Test File
- File Name: `EndpointExtractionTests.swift`
- Location: `OpenAPIHandlerGen/Tests/EndpointExtractionTests.swift`
- Purpose: Implement tests to validate endpoint handling and error cases.

### Step 3: Implement Endpoint Extraction Tests

```swift
import XCTest
@testable import OpenAPIHandlerGen

final class EndpointExtractionTests: XCTestCase {

    // Test valid endpoint extraction
    func testValidEndpointExtraction() throws {
        let yaml = """
        openapi: 3.0.0
        paths:
          /users:
            get:
              operationId: getUsers
              responses:
                '200':
                  description: Success
        """
        let endpoints = try EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints.count, 1, "Should extract 1 endpoint.")
        XCTAssertEqual(endpoints[0].path, "/users")
        XCTAssertEqual(endpoints[0].method, "GET")
        XCTAssertEqual(endpoints[0].operationId, "getUsers")
    }

    // Test duplicate endpoints
    func testDuplicateEndpoints() throws {
        let yaml = """
        openapi: 3.0.0
        paths:
          /users:
            get:
              operationId: getUsers
            post:
              operationId: getUsers
        """
        XCTAssertThrowsError(try EndpointExtractor.extractEndpoints(from: yaml)) { error in
            XCTAssertNotNil(error, "Should throw error for duplicate operation IDs.")
        }
    }

    // Test incomplete endpoint definition
    func testIncompleteEndpoint() throws {
        let yaml = """
        openapi: 3.0.0
        paths:
          /users:
            get:
              responses:
        """
        XCTAssertThrowsError(try EndpointExtractor.extractEndpoints(from: yaml), "Incomplete endpoint should throw an error.")
    }

    // Test missing paths
    func testMissingPaths() throws {
        let yaml = """
        openapi: 3.0.0
        info:
          title: API
        """
        let endpoints = try EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints.count, 0, "Should not extract endpoints when no paths are defined.")
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

## CI/CD Integration
The pipeline is configured to automatically detect and execute all test files in the `Tests` directory. Simply adding test files will ensure they are picked up during CI/CD execution.

- Test logs are uploaded as artifacts for debugging.
- No additional CI configuration is required.

---

## Next Steps
- Expand tests to validate additional error handling scenarios.
- Confirm test results in CI logs after adding new cases.

---

## Commit Reference
This implementation addresses **Prompt 5** and enhances endpoint validation tests, supporting tasks outlined in **Issue #12**.

```bash
git add Docs/Prompts/Prompt\ 5\ Endpoint\ Extraction\ Tests.md

git commit -m "docs(prompts): Add endpoint extraction tests. References #12."

git push
```

---

## Conclusion
This prompt establishes tests for endpoint extraction, ensuring correctness in path parsing, method validation, and error handling. It provides a foundation for validating endpoint implementations in Vapor and integrates seamlessly with the existing CI/CD pipeline.

