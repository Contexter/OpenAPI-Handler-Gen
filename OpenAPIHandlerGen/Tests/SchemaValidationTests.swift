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
