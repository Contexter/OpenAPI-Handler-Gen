// File: Tests/ModelGeneratorTests/ModelDirectoryCreationTests.swift

import XCTest

final class ModelDirectoryCreationTests: XCTestCase {

    func testReadOnlyDirectoryThrowsError() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("ReadOnlyModels").path
        try? FileManager.default.removeItem(atPath: outputPath)
        try FileManager.default.createDirectory(atPath: outputPath, withIntermediateDirectories: true)

        let fileURL = URL(fileURLWithPath: outputPath)
        try FileManager.default.setAttributes([.posixPermissions: 0o400], ofItemAtPath: fileURL.path)

        let models = [Model(name: "User", properties: [Property(name: "id", type: "Int")])]
        XCTAssertThrowsError(try ModelGenerator.generate(models: models, outputPath: outputPath)) { error in
            XCTAssertEqual((error as NSError).code, 13) // Permission denied
        }
        try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: fileURL.path)
    }

    func testPathCollisionWithFile() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("ModelsPathCollision").path
        try? FileManager.default.removeItem(atPath: outputPath)
        FileManager.default.createFile(atPath: outputPath, contents: nil)

        let models = [Model(name: "User", properties: [Property(name: "id", type: "Int")])]
        XCTAssertThrowsError(try ModelGenerator.generate(models: models, outputPath: outputPath))
    }

    func testValidDirectoryCreation() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("ValidModels").path
        try? FileManager.default.removeItem(atPath: outputPath)

        let models = [Model(name: "User", properties: [Property(name: "id", type: "Int")])]
        XCTAssertNoThrow(try ModelGenerator.generate(models: models, outputPath: outputPath))
        XCTAssertTrue(FileManager.default.fileExists(atPath: outputPath))
    }
}

