import XCTest
@testable import OpenAPIHandlerGen // Ensure this imports the correct module where HandlerGenerator is defined.

final class HandlerGeneratorTests: XCTestCase {

    func testHandlerAndServiceDirectoriesCreated() throws {
        let endpoint = OpenAPIFileEndpointExtractor.Endpoint(path: "/users", operationId: "getUsers")
        let method = "GET"
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("TestOutput").path

        try? FileManager.default.removeItem(atPath: outputPath) // Clean up before test

        try HandlerGenerator.generate(endpoint: endpoint, method: method, outputPath: outputPath)

        let handlersDirectory = outputPath + "/Handlers"
        let servicesDirectory = outputPath + "/Services"

        XCTAssertTrue(FileManager.default.fileExists(atPath: handlersDirectory), "Handlers directory was not created.")
        XCTAssertTrue(FileManager.default.fileExists(atPath: servicesDirectory), "Services directory was not created.")
    }
}
