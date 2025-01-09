// File: OpenAPIHandlerGen/Sources/Generators/HandlerGenerator.swift

import Foundation

public struct HandlerGenerator {

    // Generates a handler for the given endpoint and method at the specified output path.
    public static func generate(endpoint: EndpointExtractor.Endpoint, method: String, outputPath: String) throws {
        // Validate outputPath before any operations.
        guard !outputPath.isEmpty else {
            throw NSError(domain: "HandlerGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "The outputPath cannot be empty."])
        }

        // Ensure outputPath is a directory.
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: outputPath, isDirectory: &isDir) {
            if !isDir.boolValue {
                throw NSError(domain: "HandlerGenerator", code: 2, userInfo: [NSLocalizedDescriptionKey: "The outputPath must be a directory, but a file was found: \(outputPath)"])
            }
        } else {
            // Create the directory if it does not exist.
            try FileManager.default.createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
        }

        // Validate endpoint fields after outputPath is confirmed valid.
        guard !endpoint.path.isEmpty, !method.isEmpty, !endpoint.operationId.isEmpty else {
            throw NSError(domain: "HandlerGenerator", code: 3, userInfo: [NSLocalizedDescriptionKey: "Endpoint is missing required fields (path, method, operationId)."])
        }

        // Construct the handler file path.
        let handlersDirectoryPath = outputPath + "/Handlers"
        let handlerFileName = "\(endpoint.operationId)Handler.swift"
        let handlerFilePath = handlersDirectoryPath + "/\(handlerFileName)"

        // Ensure the Handlers directory exists.
        if !FileManager.default.fileExists(atPath: handlersDirectoryPath, isDirectory: &isDir) || !isDir.boolValue {
            try FileManager.default.createDirectory(atPath: handlersDirectoryPath, withIntermediateDirectories: true, attributes: nil)
        }

        // Generate the handler content with proper delegation to a service.
        let handlerContent = """
        // Handler logic for \(method.uppercased()) \(endpoint.path)
        import Foundation

        func \(endpoint.operationId)Handler(request: Request) -> Response {
            do {
                // Delegate the request processing to the service layer.
                let result = try \(endpoint.operationId)Service.process(request: request)
                return Response(status: .ok, body: result)
            } catch let error as LocalizedError {
                // Handle localized errors
                return Response(status: .internalServerError, body: "An error occurred: \\(error.localizedDescription ?? "Unknown error")")
            } catch {
                // Handle generic errors
                return Response(status: .internalServerError, body: "An unexpected error occurred.")
            }
        }
        """

        // Write the handler content to the file.
        do {
            try handlerContent.write(toFile: handlerFilePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw NSError(domain: "HandlerGenerator", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to write handler content to file at path: \(handlerFilePath). Error: \(error.localizedDescription)"])
        }

        // Generate the service content for the handler.
        let servicesDirectoryPath = outputPath + "/Services"
        let serviceFileName = "\(endpoint.operationId)Service.swift"
        let serviceFilePath = servicesDirectoryPath + "/\(serviceFileName)"

        // Ensure the Services directory exists.
        if !FileManager.default.fileExists(atPath: servicesDirectoryPath, isDirectory: &isDir) || !isDir.boolValue {
            try FileManager.default.createDirectory(atPath: servicesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
        }

        // Create a corresponding service for the handler.
        let serviceContent = """
        import Foundation

        struct \(endpoint.operationId)Service {
            static func process(request: Request) throws -> String {
                // Add business logic here.
                return "Processed request for \(endpoint.operationId)."
            }
        }
        """

        // Write the service content to the file.
        do {
            try serviceContent.write(toFile: serviceFilePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw NSError(domain: "HandlerGenerator", code: 5, userInfo: [NSLocalizedDescriptionKey: "Failed to write service content to file at path: \(serviceFilePath). Error: \(error.localizedDescription)"])
        }
    }
}
