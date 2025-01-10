// File: Tests/ModelGeneratorTests/ModelContentValidationTests.swift

import XCTest

final class ModelContentValidationTests: XCTestCase {

    func testSpecialCharactersInModelNames() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("TestModels").path
        try? FileManager.default.removeItem(atPath: outputPath)

        let models = [Model(name: "Us#er$", properties: [Property(name: "id", type: "Int")])]
        XCTAssertThrowsError(try ModelGenerator.generate(models: models, outputPath: outputPath))
    }

    func testReservedKeywordInModelProperties() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("TestModels").path
        try? FileManager.default.removeItem(atPath: outputPath)

        let models = [Model(name: "User", properties: [Property(name: "class", type: "String")])]
        XCTAssertThrowsError(try ModelGenerator.generate(models: models, outputPath: outputPath))
    }

    func testValidModelContent() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("TestModels").path
        try? FileManager.default.removeItem(atPath: outputPath)

        let models = [Model(name: "User", properties: [Property(name: "id", type: "Int"), Property(name: "name", type: "String")])]
        XCTAssertNoThrow(try ModelGenerator.generate(models: models, outputPath: outputPath))
    }
}

