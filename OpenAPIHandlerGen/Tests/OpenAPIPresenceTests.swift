// File: OpenAPIHandlerGen/Tests/OpenAPIPresenceTests.swift

import XCTest

final class OpenAPIPresenceTests: XCTestCase {

    func testOpenAPIFileExists() throws {
        // Define the expected path for the OpenAPI file
        let projectRoot = FileManager.default.currentDirectoryPath
        let openAPIFilePath = "\(projectRoot)/Sources/openapi.yaml"

        // Check if the file exists
        let fileExists = FileManager.default.fileExists(atPath: openAPIFilePath)

        // Assert that the file exists
        XCTAssertTrue(fileExists, "The file 'openapi.yaml' is missing in the 'Sources/' directory. Please ensure it is present.")
    }
}
