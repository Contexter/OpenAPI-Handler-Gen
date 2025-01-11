//
// File: Tests/MigrationsGeneratorTests/VerifyGeneratedFilesTests.swift
//

import XCTest

final class VerifyGeneratedFilesTests: XCTestCase {
    
    func testTypesFileExists() {
        let fileManager = FileManager.default
        
        // Dynamically locate the project root
        guard let projectRoot = findProjectRoot() else {
            XCTFail("Failed to locate the project root.")
            return
        }
        
        // Construct the absolute path to Generated/Types.swift
        let typesFilePath = projectRoot.appendingPathComponent("Generated/Types.swift").path
        
        XCTAssertTrue(fileManager.fileExists(atPath: typesFilePath), "The file \(typesFilePath) is missing.")
    }
    
    func testServerFileExists() {
        let fileManager = FileManager.default
        
        // Dynamically locate the project root
        guard let projectRoot = findProjectRoot() else {
            XCTFail("Failed to locate the project root.")
            return
        }
        
        // Construct the absolute path to Generated/Server.swift
        let serverFilePath = projectRoot.appendingPathComponent("Generated/Server.swift").path
        
        XCTAssertTrue(fileManager.fileExists(atPath: serverFilePath), "The file \(serverFilePath) is missing.")
    }
    
    private func findProjectRoot() -> URL? {
        var currentURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        while currentURL.path != "/" {
            if FileManager.default.fileExists(atPath: currentURL.appendingPathComponent(".git").path) {
                return currentURL
            }
            currentURL.deleteLastPathComponent()
        }
        return nil
    }
}
