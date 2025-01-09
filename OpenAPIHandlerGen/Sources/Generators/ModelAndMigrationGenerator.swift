// File: OpenAPIHandlerGen/Sources/Generators/ModelAndMigrationGenerator.swift

import Foundation

public struct ModelAndMigrationGenerator {

    // Main entry point for generating models and migrations
    public static func generate(types: [TypeDefinition], outputPath: String) throws {
        guard !outputPath.isEmpty else {
            throw NSError(domain: "ModelAndMigrationGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "The outputPath cannot be empty."])
        }

        let modelsPath = outputPath + "/Models"
        let migrationsPath = outputPath + "/Migrations"
        try createDirectory(at: modelsPath)
        try createDirectory(at: migrationsPath)

        for type in types {
            let modelFilePath = modelsPath + "/\(type.name).swift"
            let modelContent = generateModel(for: type)
            try writeFile(at: modelFilePath, content: modelContent)

            let migrationFilePath = migrationsPath + "/Create\(type.name).swift"
            let migrationContent = generateMigration(for: type)
            try writeFile(at: migrationFilePath, content: migrationContent)
        }
    }

    private static func createDirectory(at path: String) throws {
        if !FileManager.default.fileExists(atPath: path) {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }

    private static func writeFile(at path: String, content: String) throws {
        try content.write(toFile: path, atomically: true, encoding: .utf8)
    }

    private static func generateModel(for type: TypeDefinition) -> String {
        let fields = type.fields.map { "    let \($0.name): \($0.type)" }.joined(separator: "\n")
        return """
        import Foundation

        struct \(type.name): Codable {
        \(fields)
        }
        """
    }

    private static func generateMigration(for type: TypeDefinition) -> String {
        let fields = type.fields.map {
            if let constraints = $0.constraints, constraints.contains("unique") {
                return "            .field(\"\($0.name)\", .\($0.type), .required).unique(on: \"\($0.name)\")"
            }
            return "            .field(\"\($0.name)\", .\($0.type), .required)"
        }.joined(separator: "\n")
        return """
        import Fluent

        struct Create\(type.name): Migration {
            func prepare(on database: Database) -> EventLoopFuture<Void> {
                database.schema("\(type.name.lowercased())s")
                    .id()
        \(fields)
                    .create()
            }

            func revert(on database: Database) -> EventLoopFuture<Void> {
                database.schema("\(type.name.lowercased())s").delete()
            }
        }
        """
    }
}
