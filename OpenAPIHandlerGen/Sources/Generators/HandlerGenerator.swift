// File: Sources/Generators/HandlerGenerator.swift
import Vapor

struct HandlerGenerator {
    static func generate(endpoint: EndpointExtractor.Endpoint, method: String, outputPath: String) throws {
        let template = """
        import Vapor

        struct \(method)Handler: APIProtocol {
            let service = \(method)Service()

            func \(method)(_ input: Operations.\(method).Input) async throws -> Operations.\(method).Output {
                let result = try await service.execute(input: input)
                return .ok(result)
            }
        }
        """
        let filePath = "\(outputPath)/Handlers/\(method)Handler.swift"
        try template.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
    }
}
