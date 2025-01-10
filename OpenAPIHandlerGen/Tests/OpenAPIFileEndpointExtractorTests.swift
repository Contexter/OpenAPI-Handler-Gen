import XCTest
@testable import OpenAPIHandlerGen // Ensure this imports the correct module where OpenAPIFileEndpointExtractor is defined.

final class OpenAPIFileEndpointExtractorTests: XCTestCase {

    func testExtractEndpoints() throws {
        let openAPIContent: [String: Any] = [
            "paths": [
                "/users": [
                    "get": ["operationId": "getUsers"]
                ]
            ]
        ]

        let endpoints = OpenAPIFileEndpointExtractor.extractEndpoints(fromOpenAPIFile: openAPIContent)

        XCTAssertEqual(endpoints.count, 1)
        XCTAssertEqual(endpoints[0].path, "/users")
        XCTAssertEqual(endpoints[0].operationId, "getUsers")
    }

    func testInvalidEndpointParsing() throws {
        let openAPIContent: [String: Any] = [
            "paths": [
                "/users": [
                    "INVALIDMETHOD": ["operationId": "invalidOperation"]
                ]
            ]
        ]

        let endpoints = OpenAPIFileEndpointExtractor.extractEndpoints(fromOpenAPIFile: openAPIContent)
        XCTAssertEqual(endpoints.count, 0) // Ensure invalid methods are ignored
    }

    func testNoEndpoints() throws {
        let openAPIContent: [String: Any] = ["paths": [:]]
        let endpoints = OpenAPIFileEndpointExtractor.extractEndpoints(fromOpenAPIFile: openAPIContent)
        XCTAssertEqual(endpoints.count, 0) // Ensure no endpoints are extracted
    }
}
