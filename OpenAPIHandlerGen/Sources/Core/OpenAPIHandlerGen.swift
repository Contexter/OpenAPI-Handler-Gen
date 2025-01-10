// File: Sources/Core/OpenAPIHandlerGen.swift

import Foundation

struct OpenAPIHandlerGen {
    let openAPIPath: String
    let serverPath: String
    let typesPath: String
    let outputPath: String

    init(openAPIPath: String, serverPath: String, typesPath: String, outputPath: String) {
        self.openAPIPath = openAPIPath
        self.serverPath = serverPath
        self.typesPath = typesPath
        self.outputPath = outputPath
    }

    // Orchestrates the process of parsing, extracting, and generating code
    func run() throws {
        // Step 1: Parse the OpenAPI YAML file into a dictionary
        let parsedYAML = try YAMLParser.parse(at: openAPIPath)

        // Step 2: Extract endpoints using OpenAPIFileEndpointExtractor
        let endpoints = OpenAPIFileEndpointExtractor.extractEndpoints(fromOpenAPIFile: parsedYAML)

        // Step 3: Generate handlers and services
        try OpenAPIHandlerGen.generateHandlers(from: endpoints, outputPath: outputPath)
    }

    // Generates handlers and services for extracted endpoints
    static func generateHandlers(from endpoints: [OpenAPIFileEndpointExtractor.Endpoint], outputPath: String) throws {
        for endpoint in endpoints {
            // `HandlerGenerator.generate` requires `try`
            try HandlerGenerator.generate(endpoint: endpoint, method: endpoint.operationId, outputPath: outputPath)

            // `ServiceGenerator.generate` is non-throwing
            ServiceGenerator.generate(endpoint: endpoint, method: endpoint.operationId, outputPath: outputPath)
        }
    }
}
