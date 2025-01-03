# Comprehensive Test Suite for OpenAPIHandlerGen

## 1. Overview
This document outlines the test suite developed for the **OpenAPIHandlerGen** tool, which generates Swift code for handlers, services, and SQLite models based on OpenAPI specifications. The tests validate the tool's ability to parse OpenAPI files, extract endpoint details, and generate the expected outputs.

The test suite uses Swift's **XCTest** framework and focuses on functional, integration, and regression testing.

---

## 2. Test Coverage

### **1. Input Parsing Tests**
- **Purpose**: Ensure the tool correctly handles valid and invalid OpenAPI inputs.
- **Cases**:
  1. Valid OpenAPI YAML file.
  2. Invalid or malformed YAML file.
  3. Missing required fields in YAML.
  4. Empty or non-existent input paths.

### **2. Handler and Service Generation Tests**
- **Purpose**: Confirm that the tool generates handlers and services aligned with the OpenAPI specification.
- **Cases**:
  1. Validate file creation in the output directory.
  2. Verify handlers and services match expected outputs (content comparison).

### **3. Output Validation Tests**
- **Purpose**: Ensure generated handlers and services comply with syntax and structure expectations.
- **Cases**:
  1. Generated code compiles without errors.
  2. Handlers contain the expected methods and structure.
  3. Services include placeholders for business logic and proper imports.

> **Note**: Model and migration validation is planned for future releases once these features are implemented.
- **Purpose**: Ensure generated files comply with syntax and structure expectations.
- **Cases**:
  1. Generated code compiles without errors.
  2. Handlers contain the expected methods and structure.
  3. Services include placeholders for business logic and proper imports.

### **4. Migration Tests (SQLite Models)**

> **Note**: Migration generation is not yet implemented. This section outlines future tests for validating SQLite schema generation when the feature becomes available.

- **Purpose**: Test migrations for SQLite schema generation.
- **Cases**:
  1. Verify that migrations match the OpenAPI schema.
  2. Check required fields, optional fields, and relationships.
- **Purpose**: Test migrations for SQLite schema generation.
- **Cases**:
  1. Verify that migrations match the OpenAPI schema.
  2. Check required fields, optional fields, and relationships.

### **5. End-to-End Tests**
- **Purpose**: Simulate the process from parsing the OpenAPI file to generating handlers and services.
- **Cases**:
  1. Confirm no runtime errors when executing the tool.
  2. Validate handler and service generation matches expected outputs.

> **Note**: Migration tests will be deferred until migration generation is implemented.

---

## 3. Project Structure

```
OpenAPIHandlerGen/
├── Package.swift
├── Sources/
│   ├── OpenAPIHandlerGen.swift
│   └── main.swift
└── Tests/
    ├── OpenAPIHandlerGenTests/
    │   ├── ExampleFiles/
    │   │   ├── openapi.yaml
    │   │   ├── server.swift
    │   │   ├── types.swift
    │   ├── TestAssets/
    │   │   ├── ExpectedHandlers/
    │   │   ├── ExpectedServices/
    │   │   └── ExpectedModels/
    │   ├── OpenAPIHandlerGenTests.swift
    │   └── TestUtilities.swift
```

---

## 4. Example Test Cases

### **Test 1: Valid Parsing**
```swift
func testValidOpenAPIParsing() throws {
    let generator = OpenAPIHandlerGen(
        openAPIPath: validOpenAPIPath,
        serverPath: serverPath,
        typesPath: typesPath,
        outputPath: outputPath
    )
    XCTAssertNoThrow(try generator.run())
}
```

### **Test 2: Handler and Service Generation**
```swift
func testGeneratedHandlersAndServices() throws {
    let generator = OpenAPIHandlerGen(
        openAPIPath: validOpenAPIPath,
        serverPath: serverPath,
        typesPath: typesPath,
        outputPath: outputPath
    )
    try generator.run()

    // Validate Handler
    let handlerPath = "\(outputPath)/Handlers/GetWorkflowHandler.swift"
    let expectedHandler = try String(contentsOfFile: Bundle.module.path(forResource: "ExpectedHandlers/GetWorkflowHandler", ofType: "swift")!)
    let generatedHandler = try String(contentsOfFile: handlerPath)
    XCTAssertEqual(generatedHandler, expectedHandler)

    // Validate Service
    let servicePath = "\(outputPath)/Services/GetWorkflowService.swift"
    let expectedService = try String(contentsOfFile: Bundle.module.path(forResource: "ExpectedServices/GetWorkflowService", ofType: "swift")!)
    let generatedService = try String(contentsOfFile: servicePath)
    XCTAssertEqual(generatedService, expectedService)
}
```

### **Test 3: Migration Generation**
```swift
func testMigrationGeneration() throws {
    let generator = OpenAPIHandlerGen(
        openAPIPath: validOpenAPIPath,
        serverPath: serverPath,
        typesPath: typesPath,
        outputPath: outputPath
    )
    try generator.run()

    let generatedMigration = try String(contentsOfFile: "\(outputPath)/Migrations/CreateWorkflow.swift")
    let expectedMigration = try String(contentsOfFile: Bundle.module.path(forResource: "ExpectedModels/CreateWorkflow", ofType: "swift")!)
    XCTAssertEqual(generatedMigration, expectedMigration)
}
```

### **Test 4: Invalid Parsing**
```swift
func testInvalidOpenAPIParsing() throws {
    let invalidPath = Bundle.module.path(forResource: "invalid-openapi", ofType: "yaml")!
    let generator = OpenAPIHandlerGen(
        openAPIPath: invalidPath,
        serverPath: serverPath,
        typesPath: typesPath,
        outputPath: outputPath
    )
    XCTAssertThrowsError(try generator.run())
}
```

---

## 5. Running Tests

1. **Build Tests**:
   ```bash
   swift build
   ```

2. **Run All Tests**:
   ```bash
   swift test
   ```

3. **Run Specific Test**:
   ```bash
   swift test --filter OpenAPIHandlerGenTests/testValidOpenAPIParsing
   ```

---

## 6. Next Steps
1. **Add Test Assets**: Populate the `TestAssets/` folder with expected output files based on real-world examples uploaded.
2. **Enhance Tests**: Add cases for relationships, nullable fields, and nested objects.
3. **Validate Migrations**: Test SQLite schema creation with generated migrations.
4. **CI Integration**: Automate test execution using GitHub Actions or similar pipelines.

---

## 7. Conclusion
This test suite ensures the **OpenAPIHandlerGen** tool produces reliable and consistent outputs aligned with OpenAPI specifications. It covers edge cases, invalid inputs, and complete workflows, making it robust for iterative development and production use.

