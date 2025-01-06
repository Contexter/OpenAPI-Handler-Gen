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
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("testValidSchemaParsing.yaml")
        try yaml.write(to: tempURL, atomically: true, encoding: .utf8)

        let schema = try YAMLParser.parse(at: tempURL.path)
        XCTAssertNotNil(schema["components"], "Expected components key in schema")
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
