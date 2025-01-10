// File: Sources/Generators/ServiceGenerator.swift

import Vapor

struct ServiceGenerator {
    static func generate(endpoint: OpenAPIFileEndpointExtractor.Endpoint, method: String, outputPath: String) {
        let template = """
        import Vapor

        struct \(method)Service {
            func execute(input: Operations.\(method).Input) async throws -> Operations.\(method).Output {
                return .init()
            }
        }
        """
        let servicesDirectory = "\(outputPath)/Services"
        let serviceFilePath = "\(servicesDirectory)/\(method)Service.swift"
        try? FileManager.default.createDirectory(atPath: servicesDirectory, withIntermediateDirectories: true)
        try? template.write(to: URL(fileURLWithPath: serviceFilePath), atomically: true, encoding: .utf8)
    }
}
