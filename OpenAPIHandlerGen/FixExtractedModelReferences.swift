import Foundation

let projectPath = FileManager.default.currentDirectoryPath

/// Define the `ExtractedModel` struct content.
let extractedModelDefinition = """
/// Represents an extracted model with a name and body.
public struct ExtractedModel {
    public let name: String
    public let body: String

    public init(name: String, body: String) {
        self.name = name
        self.body = body
    }
}
"""

/// Files that need the `ExtractedModel` definition.
let targetFiles = [
    "Sources/Extractors/TypesFileExtractor.swift",
    "Tests/ModelGeneratorTests/ModelGeneratorTests.swift"
]

/// Add the `ExtractedModel` definition to the specified file.
func addExtractedModelDefinition(to filePath: String) {
    let fullPath = "\(projectPath)/\(filePath)"
    guard FileManager.default.fileExists(atPath: fullPath) else {
        print("❌ File not found: \(filePath)")
        return
    }

    do {
        let content = try String(contentsOfFile: fullPath, encoding: .utf8)
        if content.contains("struct ExtractedModel") {
            print("✅ ExtractedModel already defined in \(filePath)")
            return
        }

        let updatedContent = extractedModelDefinition + "\n\n" + content
        try updatedContent.write(toFile: fullPath, atomically: true, encoding: .utf8)
        print("✅ Added ExtractedModel to \(filePath)")
    } catch {
        print("❌ Failed to update \(filePath): \(error)")
    }
}

/// Remove references to the `Common` directory.
func removeCommonReferences() {
    do {
        let files = try FileManager.default.contentsOfDirectory(atPath: projectPath + "/Sources")
        for file in files where file.hasSuffix(".swift") {
            let fullPath = "\(projectPath)/Sources/\(file)"
            var content = try String(contentsOfFile: fullPath, encoding: .utf8)
            if content.contains("import Common") {
                content = content.replacingOccurrences(of: "import Common", with: "")
                try content.write(toFile: fullPath, atomically: true, encoding: .utf8)
                print("✅ Removed 'import Common' from \(file)")
            }
        }
    } catch {
        print("❌ Failed to remove 'import Common' references: \(error)")
    }
}

// Add the `ExtractedModel` definition to target files.
for file in targetFiles {
    addExtractedModelDefinition(to: file)
}

// Remove any residual references to `Common`.
removeCommonReferences()

print("🚀 Codebase update complete!")

