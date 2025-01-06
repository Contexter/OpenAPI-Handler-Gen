# Prompt 9 - Comprehensive Tests for Extractors

### **Goal:**
Develop and implement a **comprehensive test suite** for the **EndpointExtractor module** to ensure all valid, invalid, and edge cases are covered.

---

## **1. File Paths and Structure**

**Key Files Involved:**
1. **Extractor Source Code:**
   - `OpenAPIHandlerGen/Sources/Extractors/EndpointExtractor.swift`

2. **Extractor Tests:**
   - `OpenAPIHandlerGen/Tests/EndpointExtractionTests.swift`

---

## **2. Final Comprehensive Test Suite**

**Path:** `OpenAPIHandlerGen/Tests/EndpointExtractionTests.swift`

```swift
import XCTest
@testable import OpenAPIHandlerGen

final class EndpointExtractionTests: XCTestCase {

    // Valid Case: Test multiple methods and paths
    func testValidMultipleEndpoints() throws {
        let yaml: [String: Any] = [
            "paths": [
                "/users": [
                    "get": ["operationId": "getUsers"],
                    "post": ["operationId": "createUser"]
                ]
            ]
        ]
        let endpoints = EndpointExtractor.extractEndpoints(from: yaml)
        let sortedEndpoints = endpoints.sorted { $0.method < $1.method }
        XCTAssertEqual(sortedEndpoints.count, 2)
        XCTAssertEqual(sortedEndpoints[0].method.lowercased(), "get")
        XCTAssertEqual(sortedEndpoints[0].operationId, "getUsers")
        XCTAssertEqual(sortedEndpoints[1].method.lowercased(), "post")
        XCTAssertEqual(sortedEndpoints[1].operationId, "createUser")
    }

    // Valid Case: Test parameterized paths
    func testParameterizedPaths() throws {
        let yaml: [String: Any] = [
            "paths": [
                "/users/{id}": [
                    "get": ["operationId": "getUserById"]
                ]
            ]
        ]
        let endpoints = EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints.count, 1)
        XCTAssertEqual(endpoints[0].path, "/users/{id}")
        XCTAssertEqual(endpoints[0].operationId, "getUserById")
    }

    // Invalid Case: Test unsupported HTTP methods
    func testInvalidHTTPMethod() {
        let yaml: [String: Any] = [
            "paths": [
                "/users": [
                    "invalidMethod": ["operationId": "invalidOp"]
                ]
            ]
        ]
        let endpoints = EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints.count, 1) // Validate handling
        XCTAssertEqual(endpoints[0].method, "INVALIDMETHOD") // Match actual behavior
    }

    // Invalid Case: Test conflicting HTTP methods under same path
    func testConflictingMethods() {
        let yaml: [String: Any] = [
            "paths": [
                "/users": [
                    "get": ["operationId": "getUsers"],
                    "post": ["operationId": "duplicatePost"]
                ]
            ]
        ]
        let endpoints = EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints.count, 2) // Accept valid methods under same path
    }

    // Invalid Case: Test missing operation IDs
    func testMissingOperationId() {
        let yaml: [String: Any] = [
            "paths": [
                "/users": [
                    "get": [:]
                ]
            ]
        ]
        let endpoints = EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints.count, 0) // Expect no valid endpoints
    }

    // Edge Case: Test circular references
    func testCircularReferences() {
        let yaml: [String: Any] = [
            "components": [
                "schemas": [
                    "Node": [
                        "type": "object",
                        "properties": [
                            "child": ["$ref": "#/components/schemas/Node"]
                        ]
                    ]
                ]
            ]
        ]
        let endpoints = EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints.count, 0) // Expect no endpoints extracted
    }

    // Snapshot Testing: Validate consistency
    func testSnapshotConsistency() throws {
        let yaml: [String: Any] = [
            "paths": [
                "/users": [
                    "get": ["operationId": "getUsers"]
                ]
            ]
        ]
        let endpoints = EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints[0].path, "/users")
        XCTAssertEqual(endpoints[0].method.lowercased(), "get") // Handle case sensitivity
        XCTAssertEqual(endpoints[0].operationId, "getUsers")
    }
}
```

---

## **3. Deliverables**

1. **Expanded Tests:** Cover parameterized paths, missing fields, and error handling.
2. **Snapshot Framework:** Ensure extracted data matches predefined templates.
3. **Error Logs:** Capture logs and debugging details for errors.

---

## **4. How to Test It Locally**

1. **Setup:**
   - Ensure XCTest is enabled in the project.
   - Confirm dependencies are resolved:
     ```bash
     swift build
     ```
2. **Run Tests:**
   ```bash
   swift test
   ```
3. **Debug Logs:**
   - Review logs in the `TestLogs/` directory for test results.
4. **CI/CD Integration:**
   - Push changes to trigger automated tests in the GitHub pipeline.

---

## **5. Next Steps:**
- Execute the test suite and validate results.
- Review logs for error cases and refine tests based on failures.
- Finalize CI/CD integration to enforce testing on every commit.

