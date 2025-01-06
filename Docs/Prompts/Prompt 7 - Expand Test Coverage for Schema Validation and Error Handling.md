# Prompt 7 - Expand Test Coverage for Schema Validation and Error Handling

---

## **Goal**  
Enhance test coverage by validating schema parsing, error handling, and YAML extraction with comprehensive edge-case scenarios. This prompt builds on modularized components defined in **Prompt 6**.

---

## **Execution**  

### **Step 1: Schema Validation Tests**  
- **Purpose:** Ensure correct handling of schema mappings, optional fields, and invalid configurations.  
- **File:** `Tests/SchemaValidationTests.swift`  

**Example Code:**  
```swift
import XCTest
@testable import OpenAPIHandlerGen

final class SchemaValidationTests: XCTestCase {

    func testValidSchemaParsing() throws {
        let yaml = """
        components:
          schemas:
            User:
              type: object
              properties:
                id:
                  type: string
                age:
                  type: integer
        """
        let schema = try YAMLParser.parse(yaml)
        XCTAssertNotNil(schema["components"])
    }

    func testInvalidSchemaParsing() throws {
        let yaml = """
        components:
          schemas:
            User:
              type: object
              properties:
                id:
                  type: unsupportedType
        """
        XCTAssertThrowsError(try YAMLParser.parse(yaml))
    }
}
```

---

### **Step 2: Error Handling Tests**  
- **Purpose:** Validate behavior for invalid YAML structures, schema mismatches, and parsing failures.  
- **File:** `Tests/ErrorHandlingTests.swift`  

**Example Code:**  
```swift
import XCTest
@testable import OpenAPIHandlerGen

final class ErrorHandlingTests: XCTestCase {

    func testMalformedYAML() throws {
        let invalidYAML = """
        openapi: 3.0.0
        info: [title: Test API]
        """
        XCTAssertThrowsError(try YAMLParser.parse(invalidYAML))
    }

    func testMissingRequiredFields() throws {
        let yaml = """
        paths:
          /users:
            get: {}
        """
        let result = try YAMLParser.parse(yaml)
        XCTAssertNil(result["paths"]?["/users"]?["get"]?["operationId"])
    }
}
```

---

### **Step 3: Template Verification Tests**  
- **Purpose:** Validate outputs by comparing generated templates against predefined snapshots.  
- **File:** `Tests/TemplateVerificationTests.swift`  

**Example Code:**  
```swift
import XCTest
@testable import OpenAPIHandlerGen

final class TemplateVerificationTests: XCTestCase {

    func testHandlerTemplateOutput() throws {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "GET", operationId: "getUser")
        HandlerGenerator.generate(endpoint: endpoint, method: "getUser", outputPath: "/tmp")
        
        let expectedOutput = """
        import Vapor

        struct GetUserHandler: APIProtocol {
            let service = GetUserService()

            func getUser(_ input: Operations.getUser.Input) async throws -> Operations.getUser.Output {
                let result = try await service.execute(input: input)
                return .ok(result)
            }
        }
        """
        let generatedOutput = try String(contentsOfFile: "/tmp/Handlers/GetUserHandler.swift")
        XCTAssertEqual(generatedOutput.trimmingCharacters(in: .whitespacesAndNewlines),
                       expectedOutput.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
```

---

## **Environment Compatibility Update**
- Ensure CI/CD pipeline specifies **Swift version 6.0.3** to match the local development environment.
- Update `.github/workflows/ci.yml` as follows:
```yaml
- name: Set up Swift
  uses: swift-actions/setup-swift@v1
  with:
    swift-version: 6.0.3  # Updated to required Swift version
```

---

## **Next Steps**  
- Extend tests for deeply nested schemas and relationships.  
- Add more edge-case tests for schema compliance and parsing failures.  
- Ensure logs continue to be saved for later analysis.  

---

## **Commit Reference**  
**Command Example:**  
```bash
git add Docs/Prompts/Prompt\ 7\ Expand\ Test\ Coverage.md
git commit -m "docs(prompts): Add Prompt 7 - Test coverage expansion for schema validation and error handling. References #13."
git push
```

---

## **Conclusion**  
Prompt 7 introduces detailed test coverage for schema validation, YAML parsing, and template verification. It ensures reliability and supports future scalability of the codebase.

