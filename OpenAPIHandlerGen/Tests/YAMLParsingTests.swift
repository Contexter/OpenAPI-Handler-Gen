import XCTest
@testable import OpenAPIHandlerGen

final class YAMLParsingTests: XCTestCase {

    func testValidYAMLParsing() throws {
        let validYAML = """
        openapi: 3.0.0
        info:
          title: Test API
          version: 1.0.0
        """
        
        let parser = YAMLParser()
        XCTAssertNoThrow(try parser.parse(validYAML))
    }

    func testInvalidYAMLParsing() throws {
        let invalidYAML = """
        openapi: 3.0.0
        info: [title: Test API]
        """
        
        let parser = YAMLParser()
        XCTAssertThrowsError(try parser.parse(invalidYAML))
    }
}
