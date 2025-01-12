//
// File: Tests/MigrationsGeneratorTests/MigrationsOutputPlacementTests.swift
//

import XCTest

final class MigrationsOutputPlacementTests: XCTestCase {
    
    func testMigrationsDirectoryExists() {
        let migrationsDir = URL(fileURLWithPath: "Migrations")
        
        // Ensure directory exists after running the generator
        XCTAssertTrue(FileManager.default.fileExists(atPath: migrationsDir.path), "Migrations directory does not exist.")
    }
    
    func testGeneratedMigrationFilePlacement() throws {
        let migrationsDir = URL(fileURLWithPath: "Migrations")
        
        // Simulate running the generator (replace with actual generator call if available)
        simulateMigrationsGeneratorOutput()
        
        // Get list of files in the directory
        let files = try FileManager.default.contentsOfDirectory(atPath: migrationsDir.path)
        
        // Assert that at least one file exists
        XCTAssertFalse(files.isEmpty, "No migration files were generated in the Migrations directory.")
        
        // Assert file naming convention
        for file in files {
            XCTAssertTrue(file.matches(#"^\d{8}_\d{6}_.+\.swift$"#), "Migration file '\(file)' does not follow the naming convention.")
        }
    }
    
    // Helper function to simulate generator output
    private func simulateMigrationsGeneratorOutput() {
        let migrationsDir = URL(fileURLWithPath: "Migrations")
        let fileName = "\(currentTimestamp())_CreateUsersTable.swift"
        let filePath = migrationsDir.appendingPathComponent(fileName)
        
        // Ensure the directory exists
        try? FileManager.default.createDirectory(at: migrationsDir, withIntermediateDirectories: true)
        
        // Write a dummy migration file
        try? "struct CreateUsersTable: Migration {}".write(to: filePath, atomically: true, encoding: .utf8)
    }
    
    // Helper function to generate a timestamp
    private func currentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: Date())
    }
}

extension String {
    // Helper to match file names with regex
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }
}

