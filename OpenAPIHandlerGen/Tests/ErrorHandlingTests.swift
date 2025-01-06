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
