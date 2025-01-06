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

    func testMissingRequiredFields() throws {
        let yaml = """
        paths:
          /users:
            get: {}
        """
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("testMissingRequiredFields.yaml")
        try yaml.write(to: tempURL, atomically: true, encoding: .utf8)

        let result = try YAMLParser.parse(at: tempURL.path)
        let paths = result["paths"] as? [String: Any]
        let users = paths?["/users"] as? [String: Any]
        let getMethod = users?["get"] as? [String: Any]
        let operationId = getMethod?["operationId"]
        XCTAssertNil(operationId)
    }
}
