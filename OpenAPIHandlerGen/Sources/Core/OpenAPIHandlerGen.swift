// File: Sources/Core/OpenAPIHandlerGen.swift
import Foundation

struct OpenAPIHandlerGen {
    let openAPIPath: String
    let serverPath: String
    let typesPath: String
    let outputPath: String

    func run() throws {
        let openAPI = try YAMLParser.parse(at: openAPIPath)
        let endpoints = EndpointExtractor.extractEndpoints(from: openAPI)

        for endpoint in endpoints {
            HandlerGenerator.generate(endpoint: endpoint, method: endpoint.operationId, outputPath: outputPath)
            ServiceGenerator.generate(endpoint: endpoint, method: endpoint.operationId, outputPath: outputPath)
        }
        print("Generation complete!")
    }
}
