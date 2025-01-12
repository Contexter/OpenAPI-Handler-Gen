/// Represents an extracted model with a name and body.
public struct ExtractedModel {
    public let name: String
    public let body: String

    public init(name: String, body: String) {
        self.name = name
        self.body = body
    }
}

// File: Sources/Extractors/TypesFileExtractor.swift

import Foundation
import RegexBuilder

/// Extractor for parsing struct definitions from a file.
@available(macOS 13.0, *)
public class TypesFileExtractor {
    /// Extracts models defined in the content.
    public static func extractModels(from content: String) -> [ExtractedModel] {
        let regex = Regex {
            "struct"
            OneOrMore(.whitespace)
            Capture {
                OneOrMore(.word) // Struct name
            }
            ZeroOrMore(.whitespace)
            "{"
            Capture {
                ZeroOrMore {
                    NegativeLookahead("}")
                    CharacterClass.any
                }
            } // Struct body
            "}"
        }

        let matches = content.matches(of: regex)
        return matches.map { match in
            ExtractedModel(
                name: String(match.output.1),
                body: String(match.output.2)
            )
        }
    }
}
