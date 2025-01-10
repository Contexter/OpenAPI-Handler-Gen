// File: Sources/Parsers/YAMLParser.swift
import Foundation
import Yams

struct YAMLParser {
    enum YAMLParserError: Error {
        case invalidFormat
        case unsupportedType(String)
    }

    static func parse(at path: String) throws -> [String: Any] {
        let content = try String(contentsOfFile: path, encoding: .utf8)
        let yaml = try Yams.load(yaml: content)
        guard let dictionary = yaml as? [String: Any] else {
            throw YAMLParserError.invalidFormat
        }

        // Validate schema types
        if let components = (dictionary["components"] as? [String: Any])?["schemas"] as? [String: Any] {
            for (_, schema) in components {
                if let fields = (schema as? [String: Any])?["fields"] as? [String: Any] {
                    for (_, prop) in fields {
                        if let type = (prop as? [String: Any])?["type"] as? String, !isValidType(type) {
                            throw YAMLParserError.unsupportedType(type)
                        }
                    }
                }
            }
        }
        return dictionary
    }

    private static func isValidType(_ type: String) -> Bool {
        let supportedTypes = ["string", "integer", "boolean", "array", "object"]
        return supportedTypes.contains(type)
    }
}
