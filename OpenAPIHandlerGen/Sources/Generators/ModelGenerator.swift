// File: Sources/Generators/ModelGenerator.swift

import Foundation

struct ModelGenerator {

    /// Generates Swift model files based on the `Types.swift` file content.
    /// - Parameters:
    ///   - typesFilePath: Path to the `Types.swift` file containing type definitions.
    ///   - outputPath: Path to the directory where model files will be written.
    static func generate(from typesFilePath: String, outputPath: String) throws {
        // Ensure the `Types.swift` file exists
        guard FileManager.default.fileExists(atPath: typesFilePath) else {
            throw NSError(domain: "ModelGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "Types.swift file not found at \(typesFilePath)."])
        }

        // Read the content of the `Types.swift` file
        let content = try String(contentsOfFile: typesFilePath, encoding: .utf8)

        // Extract models using the `TypesFileExtractor`
        let models = TypesFileExtractor.parseModels(from: content)

        // Validate the output path
        try validateOutputPath(outputPath)

        // Define the Models directory
        let modelsDirectory = outputPath + "/Models"
        try createDirectory(at: modelsDirectory)

        // Generate each model file
        for model in models {
            try generateModelFile(for: model, in: modelsDirectory)
        }
    }

    // --- Helper Methods (as before) ---

    private static func validateOutputPath(_ path: String) throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            guard isDir.boolValue else {
                throw NSError(domain: "ModelGenerator", code: 2, userInfo: [NSLocalizedDescriptionKey: "Output path must be a directory."])
            }
        } else {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
    }

    private static func createDirectory(at path: String) throws {
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
    }

    private static func generateModelFile(for model: Model, in directory: String) throws {
        let fileName = "\(model.name).swift"
        let filePath = directory + "/\(fileName)"

        // Validate model
        try validateModel(model)

        // Generate content
        let content = generateModelContent(for: model)

        // Write the content to the file
        try content.write(toFile: filePath, atomically: true, encoding: .utf8)
    }

    private static func validateModel(_ model: Model) throws {
        let invalidCharacters = CharacterSet.alphanumerics.inverted
        guard !model.name.isEmpty, model.name.rangeOfCharacter(from: invalidCharacters) == nil else {
            throw NSError(domain: "ModelGenerator", code: 3, userInfo: [NSLocalizedDescriptionKey: "Model name contains invalid characters."])
        }
    }

    private static func generateModelContent(for model: Model) -> String {
        let properties = model.properties.map { property in
            "    let \(property.name): \(property.type)"
        }.joined(separator: "\n")

        return """
        import Foundation

        struct \(model.name): Codable {
        \(properties)
        }
        """
    }
}
