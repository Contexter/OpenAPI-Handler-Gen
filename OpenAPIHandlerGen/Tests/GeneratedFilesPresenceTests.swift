// File: OpenAPIHandlerGen/Tests/GeneratedFilesPresenceTests.swift

import XCTest

final class GeneratedFilesPresenceTests: XCTestCase {
    func testGeneratedFilesExist() throws {
        // Step 1: Find the repository root
        let currentPath = FileManager.default.currentDirectoryPath
        let repoRoot = URL(fileURLWithPath: currentPath)
            .deletingLastPathComponent() // Move from 'OpenAPIHandlerGen' to repo root

        // Step 2: Construct paths to the 'Generated' files
        let generatedFolder = repoRoot.appendingPathComponent("Generated")
        let typesPath = generatedFolder.appendingPathComponent("Types.swift").path
        let serverPath = generatedFolder.appendingPathComponent("Server.swift").path

        // Step 3: Assert file existence
        XCTAssertTrue(FileManager.default.fileExists(atPath: typesPath),
                      "The file 'Types.swift' is missing in the 'Generated' folder at the repository root.")
        XCTAssertTrue(FileManager.default.fileExists(atPath: serverPath),
                      "The file 'Server.swift' is missing in the 'Generated' folder at the repository root.")
    }
}
