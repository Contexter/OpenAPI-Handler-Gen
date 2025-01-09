// File: OpenAPIHandlerGen/Sources/Core/OpenAPIHandlerGen.swift

import Foundation

struct OpenAPIHandlerGen {
    static func generateHandlers(from endpoints: [Endpoint], outputPath: String) throws {
        for endpoint in endpoints {
            do {
                try HandlerGenerator.generate(endpoint: endpoint, method: endpoint.operationId, outputPath: outputPath)
                try ServiceGenerator.generate(endpoint: endpoint, method: endpoint.operationId, outputPath: outputPath)
            } catch {
                print("Error generating handler or service for endpoint \(endpoint.operationId): \(error)")
                throw error
            }
        }
    }
}
