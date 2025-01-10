import Foundation

public struct HandlerGenerator {

    // Generates a handler for the given endpoint and method at the specified output path.
    public static func generate(endpoint: OpenAPIFileEndpointExtractor.Endpoint, method: String, outputPath: String) throws {
        guard !outputPath.isEmpty else {
            throw NSError(domain: "HandlerGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "The outputPath cannot be empty."])
        }

        let handlersDirectoryPath = outputPath + "/Handlers"
        let servicesDirectoryPath = outputPath + "/Services"

        // Ensure Handlers directory exists
        try FileManager.default.createDirectory(atPath: handlersDirectoryPath, withIntermediateDirectories: true, attributes: nil)

        // Ensure Services directory exists
        try FileManager.default.createDirectory(atPath: servicesDirectoryPath, withIntermediateDirectories: true, attributes: nil)

        let handlerFileName = "\(endpoint.operationId)Handler.swift"
        let handlerFilePath = handlersDirectoryPath + "/\(handlerFileName)"
        let handlerContent = """
        // Handler logic for \(method.uppercased()) \(endpoint.path)
        import Foundation

        func \(endpoint.operationId)Handler(request: Request) -> Response {
            do {
                let result = try \(endpoint.operationId)Service.process(request: request)
                return Response(status: .ok, body: result)
            } catch {
                return Response(status: .internalServerError, body: "Error occurred.")
            }
        }
        """
        try handlerContent.write(toFile: handlerFilePath, atomically: true, encoding: .utf8)
    }
}
