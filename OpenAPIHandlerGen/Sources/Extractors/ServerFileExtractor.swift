// Path: Sources/Extractors/ServerFileExtractor.swift

import Foundation

internal struct ServerFileExtractor {
    // Function to extract routes from a given file path
    internal static func extractRoutes(from filePath: String) throws -> [(method: String, path: String, handler: String)] {
        // Read the file content
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        return parseRoutes(from: fileContent)
    }

    // Function to parse routes from the file content
    internal static func parseRoutes(from fileContent: String) -> [(method: String, path: String, handler: String)] {
        var routes: [(String, String, String)] = []

        let lines = fileContent.split(separator: "\n", omittingEmptySubsequences: true)
        var currentMethod: String = "UNKNOWN"
        var currentPath: String = "/unknown"
        var currentHandler: String = "UnknownHandler"

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedLine.contains("method:") {
                if let start = trimmedLine.range(of: ".")?.upperBound,
                   let end = trimmedLine.range(of: ",")?.lowerBound {
                    currentMethod = String(trimmedLine[start..<end])
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .uppercased()
                }
            } else if trimmedLine.contains("path: server.apiPathComponentsWithServerPrefix") {
                if let start = trimmedLine.range(of: "(")?.upperBound,
                   let end = trimmedLine.range(of: ")")?.lowerBound {
                    currentPath = String(trimmedLine[start..<end])
                        .replacingOccurrences(of: "\"", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }
            } else if trimmedLine.contains("server.") && trimmedLine.contains("(") {
                if let start = trimmedLine.range(of: "server.")?.upperBound,
                   let end = trimmedLine.range(of: "(")?.lowerBound {
                    currentHandler = String(trimmedLine[start..<end])
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }

            // Check if a route is complete
            if currentMethod != "UNKNOWN", currentPath != "/unknown", currentHandler != "UnknownHandler" {
                routes.append((currentMethod, currentPath, currentHandler))

                // Reset for the next route
                currentMethod = "UNKNOWN"
                currentPath = "/unknown"
                currentHandler = "UnknownHandler"
            }
        }
        return routes
    }
}
