// File: OpenAPIHandlerGen/Tests/HandlerGeneratorTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class HandlerGeneratorTests: XCTestCase {

    // Helper function to clean up files and directories after each test.
    private func cleanUp(at path: String) {
        do {
            if FileManager.default.fileExists(atPath: path) {
                try FileManager.default.removeItem(atPath: path)
            }
        } catch {
            XCTFail("Failed to clean up test environment: \(error.localizedDescription)")
        }
    }

    func testValidHandlerGeneration() {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "GET", operationId: "getUsers")
        let method = "GET"
        let outputPath = "TestOutput"

        // Ensure clean test environment.
        cleanUp(at: outputPath)
        defer { cleanUp(at: outputPath) } // Ensure cleanup after test completion.

        do {
            try HandlerGenerator.generate(endpoint: endpoint, method: method, outputPath: outputPath)

            // Validate handler file existence and content.
            let handlerFilePath = outputPath + "/Handlers/getUsersHandler.swift"
            XCTAssertTrue(FileManager.default.fileExists(atPath: handlerFilePath), "Handler file should be created.")
            let handlerContent = try String(contentsOfFile: handlerFilePath)
            XCTAssertTrue(handlerContent.contains("func getUsersHandler"), "Handler content should contain function definition.")
            XCTAssertTrue(handlerContent.contains("try getUsersService.process"), "Handler should delegate to the service layer.")

            // Validate service file existence and content.
            let serviceFilePath = outputPath + "/Services/getUsersService.swift"
            XCTAssertTrue(FileManager.default.fileExists(atPath: serviceFilePath), "Service file should be created.")
            let serviceContent = try String(contentsOfFile: serviceFilePath)
            XCTAssertTrue(serviceContent.contains("struct getUsersService"), "Service content should define a struct.")
            XCTAssertTrue(serviceContent.contains("Processed request for getUsers."), "Service content should include business logic placeholder.")

        } catch {
            XCTFail("Handler generation failed with error: \(error.localizedDescription)")
        }
    }

    func testEmptyOutputPath() {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "GET", operationId: "getUsers")
        let method = "GET"
        let outputPath = ""

        XCTAssertThrowsError(try HandlerGenerator.generate(endpoint: endpoint, method: method, outputPath: outputPath)) { error in
            XCTAssertEqual((error as NSError).code, 1, "Error code should indicate empty outputPath.")
        }
    }

    func testOutputPathIsFile() {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "GET", operationId: "getUsers")
        let method = "GET"
        let outputPath = "TestOutputFile"

        // Create a file at the output path.
        FileManager.default.createFile(atPath: outputPath, contents: nil, attributes: nil)

        defer { cleanUp(at: outputPath) }

        XCTAssertThrowsError(try HandlerGenerator.generate(endpoint: endpoint, method: method, outputPath: outputPath)) { error in
            XCTAssertEqual((error as NSError).code, 2, "Error code should indicate outputPath is a file.")
        }
    }

    func testMissingEndpointFields() {
        let endpoint = EndpointExtractor.Endpoint(path: "", method: "", operationId: "")
        let method = ""
        let outputPath = "TestOutput"

        defer { cleanUp(at: outputPath) }

        XCTAssertThrowsError(try HandlerGenerator.generate(endpoint: endpoint, method: method, outputPath: outputPath)) { error in
            XCTAssertEqual((error as NSError).code, 3, "Error code should indicate missing endpoint fields.")
        }
    }

    func testHandlerAndServiceDirectoriesCreated() {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "GET", operationId: "getUsers")
        let method = "GET"
        let outputPath = "TestOutput"

        defer { cleanUp(at: outputPath) }

        do {
            try HandlerGenerator.generate(endpoint: endpoint, method: method, outputPath: outputPath)

            // Validate directories are created.
            var isDir: ObjCBool = false
            XCTAssertTrue(FileManager.default.fileExists(atPath: outputPath + "/Handlers", isDirectory: &isDir), "Handlers directory should be created.")
            XCTAssertTrue(isDir.boolValue, "Handlers should be a directory.")
            
            XCTAssertTrue(FileManager.default.fileExists(atPath: outputPath + "/Services", isDirectory: &isDir), "Services directory should be created.")
            XCTAssertTrue(isDir.boolValue, "Services should be a directory.")
        } catch {
            XCTFail("Handler generation failed with error: \(error.localizedDescription)")
        }
    }
}
