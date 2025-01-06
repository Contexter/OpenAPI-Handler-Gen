// File: Tests/HandlerGeneratorTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class HandlerGeneratorTests: XCTestCase {

    // Valid Test: Single Endpoint
    func testSingleEndpointGeneration() throws {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "get", operationId: "getUsers")
        let outputPath = "output.swift"

        // Generate handler code
        try HandlerGenerator.generate(endpoint: endpoint, method: "get", outputPath: outputPath)

        // Read the generated file
        let generatedCode = try String(contentsOfFile: outputPath, encoding: .utf8)

        // Expected code output
        let expected = "func getUsersHandler(req: Request) throws -> Response { ... }"
        XCTAssertEqual(generatedCode, expected)
    }

    // Valid Test: Multiple Endpoints
    func testMultipleEndpointGeneration() throws {
        let endpoints = [
            EndpointExtractor.Endpoint(path: "/users", method: "get", operationId: "getUsers"),
            EndpointExtractor.Endpoint(path: "/users", method: "post", operationId: "createUser")
        ]
        let outputPath = "output.swift"

        for endpoint in endpoints {
            try HandlerGenerator.generate(endpoint: endpoint, method: endpoint.method, outputPath: outputPath)
        }

        let expectedOutput = """
        func getUsersHandler(req: Request) throws -> Response { ... }
        func createUserHandler(req: Request) throws -> Response { ... }
        """
        let generatedCode = try String(contentsOfFile: outputPath, encoding: .utf8)
        XCTAssertEqual(generatedCode, expectedOutput)
    }

    // Invalid Test: Missing Required Fields
    func testMissingRequiredFields() throws {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "get", operationId: "")
        XCTAssertThrowsError(try HandlerGenerator.generate(endpoint: endpoint, method: "get", outputPath: "output.swift"))
    }

    // Invalid Test: Unsupported Input Types
    func testUnsupportedInputType() throws {
        let yaml = "invalid: yaml"
        XCTAssertThrowsError(try YAMLParser.parse(at: yaml))
    }

    // Edge Test: Empty Input
    func testEmptyInput() throws {
        let endpoint = EndpointExtractor.Endpoint(path: "", method: "", operationId: "")
        let outputPath = "output.swift"

        try HandlerGenerator.generate(endpoint: endpoint, method: "", outputPath: outputPath)

        let generatedCode = try String(contentsOfFile: outputPath, encoding: .utf8)
        XCTAssertEqual(generatedCode, "")
    }

    // Edge Test: Circular References
    func testCircularReferences() throws {
        let yaml = "components: { schemas: { Node: { $ref: '#/components/schemas/Node' }}}"
        XCTAssertThrowsError(try YAMLParser.parse(at: yaml))
    }

    // Snapshot Testing
    func testSnapshotConsistency() throws {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "get", operationId: "getUsers")
        let outputPath = "output.swift"

        try HandlerGenerator.generate(endpoint: endpoint, method: "get", outputPath: outputPath)

        let snapshot = "func getUsersHandler(req: Request) throws -> Response { ... }"
        let generatedCode = try String(contentsOfFile: outputPath, encoding: .utf8)
        XCTAssertEqual(generatedCode, snapshot)
    }
}
