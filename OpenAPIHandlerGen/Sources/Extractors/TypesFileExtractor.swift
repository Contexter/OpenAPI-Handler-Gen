// File: Sources/Extractors/TypesFileExtractor.swift

import Foundation

/// A utility for extracting type definitions from a `Types.swift` file.
struct TypesFileExtractor {

    /// Extracts models from the content of a `Types.swift` file.
    /// - Parameter content: The string content of the `Types.swift` file.
    /// - Returns: An array of extracted `Model` instances.
    static func extractModels(from content: String) -> [Model] {
        let regexPattern = #"struct (\w+) \{((?:.|\n)*?)\}"#
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        let matches = regex.matches(in: content, options: [], range: NSRange(content.startIndex..., in: content))

        var models: [Model] = []

        for match in matches {
            if let nameRange = Range(match.range(at: 1), in: content),
               let propertiesRange = Range(match.range(at: 2), in: content) {
                let name = String(content[nameRange])
                let propertiesString = String(content[propertiesRange])
                let properties = parseProperties(from: propertiesString)
                models.append(Model(name: name, properties: properties))
            }
        }

        return models
    }

    /// Parses properties from the body of a struct definition.
    /// - Parameter propertiesString: The body of a struct definition as a string.
    /// - Returns: An array of `Property` instances.
    private static func parseProperties(from propertiesString: String) -> [Property] {
        var properties: [Property] = []

        let lines = propertiesString.split(separator: "\n")
        for line in lines {
            let components = line.split(separator: ":", maxSplits: 1)
            if components.count == 2 {
                let name = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let type = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                properties.append(Property(name: name, type: type))
            }
        }

        return properties
    }
}
