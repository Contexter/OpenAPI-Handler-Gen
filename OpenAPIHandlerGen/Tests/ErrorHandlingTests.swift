import XCTest
@testable import OpenAPIHandlerGen

final class ErrorHandlingTests: XCTestCase {

    func testMalformedYAML() throws {
        let invalidYAML = """
        openapi: 3.0.0
        info: [title: Test API]
        """
        XCTAssertThrowsError(try YAMLParser.parse(at: invalidYAML)) // Updated 'at:' label for compatibility
    }

    func testMissingRequiredFields() throws {
        let yaml = """
        paths:
          /users:
            get: {}
        """
        let result = try YAMLParser.parse(at: yaml) // Updated 'at:' label for compatibility
        XCTAssertNil(result["paths"]?["/users"]?["get"]?["operationId"])
    }
}
