import XCTest
@testable import OpenAPIHandlerGen

final class TemplateVerificationTests: XCTestCase {

    func testHandlerTemplateOutput() throws {
        let endpoint = EndpointExtractor.Endpoint(path: "/users", method: "GET", operationId: "getUser")
        HandlerGenerator.generate(endpoint: endpoint, method: "getUser", outputPath: "/tmp")
        
        let expectedOutput = """
        import Vapor

        struct GetUserHandler: APIProtocol {
            let service = GetUserService()

            func getUser(_ input: Operations.getUser.Input) async throws -> Operations.getUser.Output {
                let result = try await service.execute(input: input)
                return .ok(result)
            }
        }
        """
        let generatedOutput = try String(contentsOfFile: "/tmp/Handlers/GetUserHandler.swift", encoding: .utf8) // Updated method to include encoding
        XCTAssertEqual(generatedOutput.trimmingCharacters(in: .whitespacesAndNewlines),
                       expectedOutput.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
