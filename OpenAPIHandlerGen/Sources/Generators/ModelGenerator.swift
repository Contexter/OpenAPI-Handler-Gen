// Sources/OpenAPIHandlerGen/ModelGenerator.swift

import Foundation

/// Errors that can occur during model generation and validation.
public enum ModelError: Error {
    case invalidModelName(String)
    case invalidPropertyName(String)
    case invalidPropertyType(String)
}

/// Represents a property of a model.
public struct Property {
    public let name: String
    public let type: String

    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

/// Represents a model with a name and properties.
public struct Model {
    public let name: String
    public let properties: [Property]

    public init(name: String, properties: [Property]) {
        self.name = name
        self.properties = properties
    }
}

/// Generates Swift code for models.
public struct ModelGenerator {
    /// Generates Swift code for a given model.
    /// - Parameter model: The model to generate code for.
    /// - Returns: The generated Swift code as a string.
    /// - Throws: `ModelError` if validation fails.
    public static func generateCode(for model: Model) throws -> String {
        // Validate the model before generating code.
        try validate(model: model)

        // Generate the Swift struct definition.
        let propertiesCode = model.properties
            .map { "    let \($0.name): \($0.type)" }
            .joined(separator: "\n")
        return """
        struct \(model.name) {
        \(propertiesCode)
        }
        """
    }

    /// Validates the model for correctness.
    /// - Parameter model: The model to validate.
    /// - Throws: `ModelError` if the model contains invalid data.
    public static func validate(model: Model) throws {
        guard isValidModelName(model.name) else {
            throw ModelError.invalidModelName(model.name)
        }

        for property in model.properties {
            guard isValidPropertyName(property.name) else {
                throw ModelError.invalidPropertyName(property.name)
            }
            guard isValidPropertyType(property.type) else {
                throw ModelError.invalidPropertyType(property.type)
            }
        }
    }

    // MARK: - Private Validation Methods

    /// Checks if a model name is valid.
    private static func isValidModelName(_ name: String) -> Bool {
        // A valid name starts with a letter and contains no spaces.
        return !name.isEmpty && name.first?.isLetter == true && !name.contains(" ")
    }

    /// Checks if a property name is valid.
    private static func isValidPropertyName(_ name: String) -> Bool {
        // A valid property name starts with a letter and contains no spaces.
        return !name.isEmpty && name.first?.isLetter == true && !name.contains(" ")
    }

    /// Checks if a property type is valid.
    private static func isValidPropertyType(_ type: String) -> Bool {
        // A valid type matches Swift's primitive types or custom types.
        let validTypes = ["Int", "String", "Bool", "Double", "Float", "Date"]
        return validTypes.contains(type) || type.first?.isUppercase == true
    }
}
