# Prompt 7 - Expand Test Coverage for Schema Validation and Error Handling

---

## **Goal**  
Enhance test coverage by validating schema parsing, error handling, and YAML extraction with comprehensive edge-case scenarios. The tests focus on cases such as unsupported data types, missing required fields, malformed YAML structures, and schema mismatches. These enhancements aim to:
- Catch errors early in development.
- Reduce runtime failures.
- Enforce compliance with OpenAPI standards.
- Provide robustness in YAML parsing and template generation.

This prompt builds on modularized components defined in **Prompt 6**.

---

## **Execution**  

### **Step 1: Schema Validation Tests**  
- **Purpose:** Ensure robust handling of schema mappings, optional fields, and invalid configurations. Focus areas include:
  - Malformed schemas.
  - Missing fields.
  - Type mismatches.

**Why It’s Useful:** Validating schemas early ensures compliance with OpenAPI standards, catches configuration errors during development, and reduces runtime failures.

- **File:** `Tests/SchemaValidationTests.swift`  

**Example Code:**  
```swift
import XCTest
@testable import OpenAPIHandlerGen

final class SchemaValidationTests: XCTestCase {

    // Test valid schema parsing with supported data types
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
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("testValidSchemaParsing.yaml")
        try yaml.write(to: tempURL, atomically: true, encoding: .utf8)

        let schema = try YAMLParser.parse(at: tempURL.path)
        XCTAssertNotNil(schema["components"], "Expected components key in schema")
    }

    // Test invalid schema parsing with unsupported data types
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
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("testInvalidSchemaParsing.yaml")
        try yaml.write(to: tempURL, atomically: true, encoding: .utf8)

        XCTAssertThrowsError(try YAMLParser.parse(at: tempURL.path)) { error in
            guard let parsingError = error as? YAMLParser.YAMLParserError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            switch parsingError {
            case .unsupportedType(let type):
                XCTAssertEqual(type, "unsupportedType", "Expected unsupported type error for 'unsupportedType'")
            default:
                XCTFail("Unexpected error case: \(parsingError)")
            }
        }
    }
}
```

---

### **Step 2: YAML Parser Implementation**  
- **Purpose:** Parse YAML content into Swift dictionary structures and handle errors with custom exceptions.
- **Why It’s Useful:** YAML parsing is central to OpenAPI-based APIs, enabling dynamic schema validation and configuration handling.

- **File:** `Sources/Parsers/YAMLParser.swift`

**Tree Structure:**  
```
Sources/
└── Parsers/
    └── YAMLParser.swift
Tests/
└── SchemaValidationTests.swift
    └── ErrorHandlingTests.swift
```

**Example Code:**  
```swift
import Foundation
import Yams

struct YAMLParser {
    enum YAMLParserError: Error {
        case invalidFormat
        case unsupportedType(String)
    }

    static func parse(at path: String) throws -> [String: Any] {
        let content = try String(contentsOfFile: path, encoding: .utf8)
        let yaml = try Yams.load(yaml: content)
        guard let dictionary = yaml as? [String: Any] else {
            throw YAMLParserError.invalidFormat
        }

        // Validate schema types
        if let components = (dictionary["components"] as? [String: Any])?["schemas"] as? [String: Any] {
            for (_, schema) in components {
                if let properties = (schema as? [String: Any])?["properties"] as? [String: Any] {
                    for (_, prop) in properties {
                        if let type = (prop as? [String: Any])?["type"] as? String, !isValidType(type) {
                            throw YAMLParserError.unsupportedType(type)
                        }
                    }
                }
            }
        }
        return dictionary
    }

    private static func isValidType(_ type: String) -> Bool {
        let supportedTypes = ["string", "integer", "boolean", "array", "object"]
        return supportedTypes.contains(type)
    }
}
```

---

### **Step 3: Error Handling Tests**  
- **Purpose:** Validate behavior for invalid YAML structures, schema mismatches, and parsing failures.  

**Why It’s Useful:** These tests verify edge cases and reduce risk of failures in production by simulating error scenarios.

**File:** `Tests/ErrorHandlingTests.swift`  

**Example Code:**  
```swift
import XCTest
@testable import OpenAPIHandlerGen

final class ErrorHandlingTests: XCTestCase {

    func testMalformedYAML() throws {
        let invalidYAML = """
        openapi: 3.0.0
        info: [title: Test API
        """
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("testMalformedYAML.yaml")
        try invalidYAML.write(to: tempURL, atomically: true, encoding: .utf8)
        XCTAssertThrowsError(try YAMLParser.parse(at: tempURL.path))
    }
}
```

---

## **Next Steps**  
- Add deeply nested schemas and relationships.
- Test compliance with OpenAPI constraints.
- Expand test cases for YAML edge scenarios.

---

## **Conclusion**  
Prompt 7 introduces test coverage for schema validation, YAML parsing, and template verification, ensuring robust API schema compliance and error handling.

