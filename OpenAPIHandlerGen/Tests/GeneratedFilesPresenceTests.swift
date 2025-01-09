// File: OpenAPIHandlerGen/Tests/GeneratedFilesPresenceTests.swift

import XCTest

final class GeneratedFilesPresenceTests: XCTestCase {

    func testGeneratedFilesExist() throws {
        // Define the root directory and the Generated folder
        let repoRoot = FileManager.default.currentDirectoryPath
        let generatedFolder = "\(repoRoot)/Generated"

        // Define paths to the expected files
        let typesFilePath = "\(generatedFolder)/Types.swift" // Capitalized
        let serverFilePath = "\(generatedFolder)/Server.swift" // Capitalized

        // Check if these files exist in the Generated folder
        let typesFileExists = FileManager.default.fileExists(atPath: typesFilePath)
        let serverFileExists = FileManager.default.fileExists(atPath: serverFilePath)

        // Assert both files are present
        XCTAssertTrue(typesFileExists, "The file 'Types.swift' is missing in the 'Generated' folder at the repository root. Please ensure it is generated.")
        XCTAssertTrue(serverFileExists, "The file 'Server.swift' is missing in the 'Generated' folder at the repository root. Please ensure it is generated.")
    }
}
