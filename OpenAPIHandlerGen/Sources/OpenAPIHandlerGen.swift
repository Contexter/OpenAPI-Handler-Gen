//
// File: OpenAPIHandlerGen.swift
// Purpose: CLI Tool to parse an OpenAPI schema and generate corresponding handlers and services.
//

import Foundation
import Yams // Library used for parsing YAML content

// MARK: - Main Program
/// Main struct responsible for orchestrating the generation of handlers and services.
struct OpenAPIHandlerGen {
    /// Path to the OpenAPI YAML file.
    let openAPIPath: String
    
    /// Path to the Swift file containing server protocol definitions (e.g., `func getUsers(...)`).
    let serverPath: String
    
    /// Path to the Swift file containing type definitions (e.g., `struct User`).
    let typesPath: String
    
    /// Path to the directory where generated Handlers and Services will be saved.
    let outputPath: String

    /// Main entry point for the generator.
    /// 1. Parses OpenAPI, server code, and type code.
    /// 2. Extracts endpoints from the OpenAPI.
    /// 3. Extracts protocol method names from the server code.
    /// 4. Extracts struct names from the types code.
    /// 5. Generates corresponding Handler and Service files.
    func run() throws {
        // Step 1: Load and Parse Input Files
        let openAPI = try parseYAML(at: openAPIPath)
        let serverCode = try String(contentsOfFile: serverPath, encoding: .utf8)
        let typesCode = try String(contentsOfFile: typesPath, encoding: .utf8)

        // Step 2: Extract Endpoint Details from the OpenAPI spec
        let endpoints = extractEndpoints(from: openAPI)
        
        // Step 2a: Extract protocol methods from the server code
        let protocolMethods = extractProtocolMethods(from: serverCode)
        
        // Step 2b: Extract type mappings from the types code (not used extensively here, but available)
        let typeMappings = extractTypeMappings(from: typesCode)

        // Step 3: For each endpoint, generate the corresponding handler/service if a matching method is found.
        for endpoint in endpoints {
            // If the operationId in the OpenAPI does not match any method from the server code, skip it.
            guard let method = protocolMethods[endpoint.operationId] else {
                print("Warning: Missing protocol method for \(endpoint.operationId)")
                continue
            }
            // Create the handler Swift file
            generateHandler(endpoint: endpoint, method: method, outputPath: outputPath)
            // Create the service Swift file
            generateService(endpoint: endpoint, method: method, outputPath: outputPath)
        }

        // Notify that generation is complete.
        print("Handler and Service generation complete!")
    }

    // MARK: - Parse YAML
    /// Loads a YAML file from disk at the given path and returns it as a dictionary.
    /// - Parameter path: File path to the YAML file.
    /// - Throws: An error if the file fails to load or the YAML is malformed.
    /// - Returns: A dictionary representing the parsed YAML content.
    private func parseYAML(at path: String) throws -> [String: Any] {
        let content = try String(contentsOfFile: path, encoding: .utf8)
        // Parse the YAML content using Yams.
        let yaml = try Yams.load(yaml: content)
        guard let dictionary = yaml as? [String: Any] else {
            throw NSError(domain: "Invalid YAML Format", code: 1, userInfo: nil)
        }
        return dictionary
    }

    // MARK: - Extract Endpoints
    /// Extracts endpoint definitions from an OpenAPI-compliant dictionary.
    /// - Parameter yaml: The dictionary representation of an OpenAPI file.
    /// - Returns: An array of `Endpoint` structs, each containing path, method, and operationId.
    private func extractEndpoints(from yaml: [String: Any]) -> [Endpoint] {
        var endpoints: [Endpoint] = []
        // The "paths" section of an OpenAPI file contains the endpoints.
        if let paths = yaml["paths"] as? [String: Any] {
            // Each path can have multiple methods (GET, POST, etc.).
            for (path, methods) in paths {
                guard let methodsDict = methods as? [String: Any] else { continue }
                // For each method, look for an operationId in the method's details.
                for (method, details) in methodsDict {
                    if let detailsDict = details as? [String: Any],
                       let operationId = detailsDict["operationId"] as? String {
                        // Store the endpoint (path, HTTP method, operationId).
                        endpoints.append(
                            Endpoint(path: path, method: method.uppercased(), operationId: operationId)
                        )
                    }
                }
            }
        }
        return endpoints
    }

    // MARK: - Extract Protocol Methods
    /// Uses a regular expression to extract method names from a Swift file.
    /// Expects the pattern `func someMethod(` to identify a function named `someMethod`.
    /// - Parameter code: The entire text content of a Swift file.
    /// - Returns: A dictionary mapping `operationId` to the method name.
    private func extractProtocolMethods(from code: String) -> [String: String] {
        var methods: [String: String] = [:]
        // Regex that captures the name of a function declared with `func someName(`.
        let regex = try! NSRegularExpression(pattern: "func (\\w+)\\(", options: [])
        
        // Get all matches in the entire code string.
        let matches = regex.matches(in: code, range: NSRange(code.startIndex..., in: code))
        for match in matches {
            // We only need the first capture group (the method name).
            if let range = Range(match.range(at: 1), in: code) {
                let methodName = String(code[range])
                // In real usage, you might need a more robust mapping (operationId -> function name).
                methods[methodName] = methodName
            }
        }
        return methods
    }

    // MARK: - Extract Type Mappings
    /// Looks for Swift `struct` declarations using a regex, e.g., `struct SomeType`.
    /// - Parameter code: The Swift code that may contain struct definitions.
    /// - Returns: A dictionary mapping each struct name to itself. Could be extended to map to something else.
    private func extractTypeMappings(from code: String) -> [String: String] {
        var mappings: [String: String] = [:]
        // This pattern looks for lines like `struct User`.
        let regex = try! NSRegularExpression(pattern: "struct (\\w+)", options: [])
        
        // Find matches throughout the file for `struct <Name>`.
        let matches = regex.matches(in: code, range: NSRange(code.startIndex..., in: code))
        for match in matches {
            // Capturing the struct name.
            if let range = Range(match.range(at: 1), in: code) {
                let typeName = String(code[range])
                mappings[typeName] = typeName
            }
        }
        return mappings
    }

    // MARK: - Generate Handler
    /// Generates a Swift file for the Handler, conforming to `APIProtocol` and referencing the appropriate service.
    /// - Parameters:
    ///   - endpoint: The endpoint data (path, method, operationId).
    ///   - method: The method name that corresponds to `endpoint.operationId`.
    ///   - outputPath: The root path where generated files should be saved.
    private func generateHandler(endpoint: Endpoint, method: String, outputPath: String) {
        // Template string that includes the file name, import statements, struct definition, etc.
        let handlerTemplate = """
        // File: Sources/Handlers/\(method)Handler.swift
        // Purpose: Handles \(endpoint.method) requests for \(endpoint.path).

        import Vapor

        struct \(method)Handler: APIProtocol {
            let service = \(method)Service()

            func \(method)(_ input: Operations.\(method).Input) async throws -> Operations.\(method).Output {
                let result = try await service.execute(input: input)
                return .ok(result)
            }
        }
        """
        // Construct the full path to save the file, then write the template.
        saveFile(content: handlerTemplate, to: outputPath + "/Handlers/\(method)Handler.swift")
    }

    // MARK: - Generate Service
    /// Generates a Swift file for the Service, containing the business logic for a given endpoint.
    /// - Parameters:
    ///   - endpoint: The endpoint data (path, method, operationId).
    ///   - method: The method name that corresponds to `endpoint.operationId`.
    ///   - outputPath: The root path where generated files should be saved.
    private func generateService(endpoint: Endpoint, method: String, outputPath: String) {
        // Template string that includes boilerplate for the service logic.
        let serviceTemplate = """
        // File: Sources/Services/\(method)Service.swift
        // Purpose: Business logic for \(endpoint.method) \(endpoint.path).

        import Vapor

        struct \(method)Service {
            func execute(input: Operations.\(method).Input) async throws -> Operations.\(method).Output {
                // TODO: Replace with actual logic.
                return .init()
            }
        }
        """
        // Construct the file path and save the service template.
        saveFile(content: serviceTemplate, to: outputPath + "/Services/\(method)Service.swift")
    }

    // MARK: - Save File
    /// Saves a file to disk, creating any needed directories first.
    /// - Parameters:
    ///   - content: The text to write.
    ///   - path: The full path (including file name) where the file should be created/overwritten.
    private func saveFile(content: String, to path: String) {
        let url = URL(fileURLWithPath: path)
        // Create any intermediate directories before saving the file.
        try? FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        // Write content to the file, ignoring errors for brevity. Consider proper error handling in production.
        try? content.write(to: url, atomically: true, encoding: .utf8)
    }
}

// MARK: - Helper Structures
/// Simple struct to hold endpoint data extracted from the OpenAPI.
struct Endpoint {
    /// The path of the endpoint, e.g., `/users`.
    let path: String
    /// The HTTP method, e.g., GET or POST.
    let method: String
    /// The operationId from the OpenAPI file, used to link to a Swift method name.
    let operationId: String
}

// MARK: - Entry Point
/// Checks that the user has provided the correct number of command-line arguments and runs the tool.
if CommandLine.arguments.count == 5 {
    // Create an instance of `OpenAPIHandlerGen` with the user-provided arguments.
    let generator = OpenAPIHandlerGen(
        openAPIPath: CommandLine.arguments[1],
        serverPath: CommandLine.arguments[2],
        typesPath: CommandLine.arguments[3],
        outputPath: CommandLine.arguments[4]
    )
    // Run the generator. If any error is thrown, execution will terminate.
    try generator.run()
} else {
    // If insufficient arguments are provided, print usage instructions.
    print("Usage: OpenAPIHandlerGen <openapi.yaml> <Server.swift> <Types.swift> <outputPath>")
}