// File: Sources/Generators/ServiceGenerator.swift
import Vapor

struct ServiceGenerator {
    static func generate(endpoint: EndpointExtractor.Endpoint, method: String, outputPath: String) {
        let template = """
        import Vapor

        struct \(method)Service {
            func execute(input: Operations.\(method).Input) async throws -> Operations.\(method).Output {
                return .init()
            }
        }
        """
        let filePath = "\(outputPath)/Services/\(method)Service.swift"
        try? template.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
    }
}
