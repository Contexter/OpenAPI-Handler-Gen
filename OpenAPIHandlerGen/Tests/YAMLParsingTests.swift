import XCTest
import Yams

final class YAMLParsingTests: XCTestCase {

    func testValidYAMLParsing() throws {
        let validYAML = """
        openapi: 3.0.0
        info:
          title: Test API
          version: 1.0.0
        """
        
        XCTAssertNoThrow(try Yams.load(yaml: validYAML))
    }

    func testInvalidYAMLParsing() throws {
        let invalidYAML = """
        openapi: 3.0.0
        info: [title: Test API]
        """
        
        XCTAssertThrowsError(try Yams.load(yaml: invalidYAML))
    }
}
