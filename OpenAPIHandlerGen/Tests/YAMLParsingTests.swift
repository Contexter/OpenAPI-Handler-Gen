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
        
        XCTAssertThrowsError(try {
            let result = try Yams.load(yaml: invalidYAML)
            // Additional validation to check structure
            guard let dict = result as? [String: Any],
                  let info = dict["info"] as? [String: Any],
                  let _ = info["title"] as? String else {
                throw NSError(domain: "YAMLValidationError", code: 0, userInfo: nil)
            }
        }())
    }
}
