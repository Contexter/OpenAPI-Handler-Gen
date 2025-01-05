import Foundation
import Yams

public struct OpenAPIHandlerGen {
    let openAPIPath: String
    let serverPath: String
    let typesPath: String
    let outputPath: String

    public init(openAPIPath: String, serverPath: String, typesPath: String, outputPath: String) {
        self.openAPIPath = openAPIPath
        self.serverPath = serverPath
        self.typesPath = typesPath
        self.outputPath = outputPath
    }

    public func run() throws {
        let openAPI = try parseYAML(at: openAPIPath)
        let serverCode = try String(contentsOfFile: serverPath, encoding: .utf8)
        let typesCode = try String(contentsOfFile: typesPath, encoding: .utf8)

        let endpoints = EndpointExtractor.extractEndpoints(from: openAPI)
        let protocolMethods = extractProtocolMethods(from: serverCode)
        let typeMappings = extractTypeMappings(from: typesCode)

        for endpoint in endpoints {
            guard let method = protocolMethods[endpoint.operationId] else {
                print("Warning: Missing protocol method for \(endpoint.operationId)")
                continue
            }
            generateHandler(endpoint: endpoint, method: method, outputPath: outputPath)
            generateService(endpoint: endpoint, method: method, outputPath: outputPath)
        }
        print("Generation complete!")
    }

    private func parseYAML(at path: String) throws -> [String: Any] {
        let content = try String(contentsOfFile: path, encoding: .utf8)
        let yaml = try Yams.load(yaml: content)
        guard let dictionary = yaml as? [String: Any] else {
            throw NSError(domain: "Invalid YAML Format", code: 1, userInfo: nil)
        }
        return dictionary
    }

    private func extractProtocolMethods(from code: String) -> [String: String] {
        var methods: [String: String] = [:]
        let regex = try! NSRegularExpression(pattern: "func (\\w+)\\(", options: [])
        let matches = regex.matches(in: code, range: NSRange(code.startIndex..., in: code))
        for match in matches {
            if let range = Range(match.range(at: 1), in: code) {
                let methodName = String(code[range])
                methods[methodName] = methodName
            }
        }
        return methods
    }

    private func extractTypeMappings(from code: String) -> [String: String] {
        var mappings: [String: String] = [:]
        let regex = try! NSRegularExpression(pattern: "struct (\\w+)", options: [])
        let matches = regex.matches(in: code, range: NSRange(code.startIndex..., in: code))
        for match in matches {
            if let range = Range(match.range(at: 1), in: code) {
                let typeName = String(code[range])
                mappings[typeName] = typeName
            }
        }
        return mappings
    }

    private func generateHandler(endpoint: EndpointExtractor.Endpoint, method: String, outputPath: String) {
        let handlerTemplate = """
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
        try? handlerTemplate.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
    }

    private func generateService(endpoint: EndpointExtractor.Endpoint, method: String, outputPath: String) {
        let serviceTemplate = """
        import Vapor

        struct \(method)Service {
            func execute(input: Operations.\(method).Input) async throws -> Operations.\(method).Output {
                return .init()
            }
        }
        """
        let filePath = "\(outputPath)/Services/\(method)Service.swift"
        try? serviceTemplate.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
    }
}
