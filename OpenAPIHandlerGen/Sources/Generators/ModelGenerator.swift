import Foundation

/// A utility responsible for generating Swift models based on parsed type definitions.
public struct ModelGenerator {

    /// Generates Swift model files based on the `Types.swift` file content.
    /// - Parameters:
    ///   - typesFilePath: Path to the `Types.swift` file containing type definitions.
    ///   - outputPath: Path to the directory where model files will be written.
    public static func generate(from typesFilePath: String, outputPath: String) throws {
        // Ensure the `Types.swift` file exists
        guard FileManager.default.fileExists(atPath: typesFilePath) else {
            throw NSError(
                domain: "ModelGenerator",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Types.swift file not found at \(typesFilePath)."]
            )
        }

        // Read the content of the `Types.swift` file
        let content = try String(contentsOfFile: typesFilePath, encoding: .utf8)

        // Extract models using the `TypesFileExtractor`
        let models = TypesFileExtractor.extractModels(from: content)

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

    // MARK: - Helper Methods

    /// Validates that the output path is a valid directory.
    /// - Parameter path: The output path to validate.
    /// - Throws: An error if the path is invalid.
    private static func validateOutputPath(_ path: String) throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            guard isDir.boolValue else {
                throw NSError(
                    domain: "ModelGenerator",
                    code: 2,
                    userInfo: [NSLocalizedDescriptionKey: "Output path must be a directory."]
                )
            }
        } else {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
    }

    /// Creates a directory at the specified path if it does not exist.
    /// - Parameter path: The path to create the directory at.
    /// - Throws: An error if the directory could not be created.
    private static func createDirectory(at path: String) throws {
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
    }

    /// Creates a directory specifically for the given model.
    /// - Parameter model: The model to create the directory for.
    /// - Returns: The created directory path.
    public static func createDirectory(for model: Model) throws -> String {
        let directoryPath = "path/to/directory/\(model.name)"
        try createDirectory(at: directoryPath)
        return directoryPath
    }

    /// Generates a Swift file for the given model in the specified directory.
    /// - Parameters:
    ///   - model: The model to generate the file for.
    ///   - directory: The directory to write the file in.
    /// - Throws: An error if the file could not be written.
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

    /// Validates the given model for invalid characters and reserved keywords.
    /// - Parameter model: The model to validate.
    /// - Throws: An error if the model name or any property name is invalid.
    public static func validateModel(_ model: Model) throws {
        let invalidCharacters = CharacterSet.alphanumerics.inverted
        let firstCharacterInvalid = model.name.unicodeScalars.first.map { CharacterSet.decimalDigits.contains($0) } ?? false

        // Ensure the model name is valid
        guard !model.name.isEmpty,
              model.name.rangeOfCharacter(from: invalidCharacters) == nil,
              !firstCharacterInvalid else {
            throw NSError(
                domain: "ModelGenerator",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Model name contains invalid characters or starts with a digit."]
            )
        }

        // Ensure property names are valid
        let reservedKeywords: Set<String> = ["class", "struct", "enum", "protocol", "func"]
        for property in model.properties {
            guard !property.name.isEmpty,
                  property.name.rangeOfCharacter(from: invalidCharacters) == nil else {
                throw NSError(
                    domain: "ModelGenerator",
                    code: 4,
                    userInfo: [NSLocalizedDescriptionKey: "Property name contains invalid characters."]
                )
            }

            guard !reservedKeywords.contains(property.name) else {
                throw NSError(
                    domain: "ModelGenerator",
                    code: 5,
                    userInfo: [NSLocalizedDescriptionKey: "Property name uses a reserved keyword."]
                )
            }
        }
    }

    /// Generates the Swift content for the given model.
    /// - Parameter model: The model to generate content for.
    /// - Returns: A Swift string representation of the model.
    public static func generateModelContent(for model: Model) -> String {
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
