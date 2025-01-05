import XCTest
@testable import OpenAPIHandlerGen

final class EndpointExtractionTests: XCTestCase {

    // Test valid endpoint extraction
    func testValidEndpointExtraction() throws {
        let yaml = [
            "paths": [
                "/users": [
                    "get": [
                        "operationId": "getUsers",
                        "responses": [
                            "200": [
                                "description": "Success"
                            ]
                        ]
                    ]
                ]
            ]
        ]
        let endpoints = EndpointExtractor.extractEndpoints(from: yaml)
        XCTAssertEqual(endpoints.count, 1, "Should extract 1 endpoint.")
        XCTAssertEqual(endpoints[0].path, "/users")
        XCTAssertEqual(endpoints[0].method, "GET")
        XCTAssertEqual(endpoints[0].operationId, "getUsers")
    }
}
