import Foundation

struct Model {
    let name: String
    let fields: [String: String]
}

class TypesFileExtractor {
    static func parseModels(from content: String) -> [Model] {
        let lines = content.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        var models: [Model] = []
        var currentModelName: String? = nil
        var currentFields: [String: String] = [:]
        var braceStack: [String] = []

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmedLine.starts(with: "struct ") {
                // Only process top-level structs
                if braceStack.isEmpty {
                    currentModelName = extractStructName(from: trimmedLine)
                    currentFields = [:]
                }
                braceStack.append("{")
            } else if trimmedLine == "{" {
                braceStack.append("{")
            } else if trimmedLine == "}" {
                if !braceStack.isEmpty {
                    braceStack.removeLast()
                }
                // Only add model when all braces are closed
                if braceStack.isEmpty, let modelName = currentModelName {
                    models.append(Model(name: modelName, fields: sortFields(fields: currentFields)))
                    currentModelName = nil
                    currentFields = [:]
                }
            } else if braceStack.count == 1, let field = extractField(from: trimmedLine) {
                // Only extract fields at the first level inside the struct
                currentFields[field.0] = field.1
            }
        }

        return models
    }

    private static func extractStructName(from line: String) -> String? {
        let components = line.split(separator: " ")
        return components.count > 1 ? String(components[1]) : nil
    }

    private static func extractField(from line: String) -> (String, String)? {
        // Handle potential cases where ":" might be within types (e.g., dictionaries)
        guard let colonIndex = line.firstIndex(of: ":") else { return nil }
        
        let fieldNamePart = line[..<colonIndex]
        let fieldTypePart = line[line.index(after: colonIndex)...]
        
        let fieldName = stripModifiers(from: String(fieldNamePart).trimmingCharacters(in: .whitespaces))
        let fieldType = String(fieldTypePart).trimmingCharacters(in: .whitespaces)
        
        return (fieldName, fieldType)
    }

    private static func stripModifiers(from field: String) -> String {
        let modifiers = ["var", "let", "static", "private", "public"]
        let words = field.split(separator: " ")
        return words.filter { !modifiers.contains(String($0)) }.joined(separator: " ")
    }

    private static func sortFields(fields: [String: String]) -> [String: String] {
        return fields.sorted { $0.key < $1.key }.reduce(into: [String: String]()) { $0[$1.key] = $1.value }
    }
}
