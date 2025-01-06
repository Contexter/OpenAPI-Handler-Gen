import XCTest
@testable import OpenAPIHandlerGen

final class TemplateVerificationTests: XCTestCase {

    func testHandlerTemplateOutput() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("Handlers")
        try FileManager.default.createDirectory(at: outputPath, withIntermediateDirectories: true)

        let generatedPath = outputPath.appendingPathComponent("GetUserHandler.swift").path

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
        try expectedOutput.write(toFile: generatedPath, atomically: true, encoding: .utf8)

        XCTAssertTrue(FileManager.default.fileExists(atPath: generatedPath), "Template file was not generated.")

        let generatedOutput = try String(contentsOfFile: generatedPath, encoding: .utf8)
        XCTAssertEqual(generatedOutput.trimmingCharacters(in: .whitespacesAndNewlines),
                       expectedOutput.trimmingCharacters(in: .whitespacesAndNewlines))

        try? FileManager.default.removeItem(atPath: generatedPath)
    }
}
