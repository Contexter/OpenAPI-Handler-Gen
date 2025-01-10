// File: Tests/ModelGeneratorTests/ModelErrorHandlingTests.swift

import XCTest

final class ModelErrorHandlingTests: XCTestCase {

    func testDuplicatePropertyNames() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("TestModels").path
        try? FileManager.default.removeItem(atPath: outputPath)

        let models = [Model(name: "User", properties: [
            Property(name: "id", type: "Int"),
            Property(name: "id", type: "String")
        ])]
        XCTAssertThrowsError(try ModelGenerator.generate(models: models, outputPath: outputPath))
    }

    func testCyclicReferences() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("TestModels").path
        try? FileManager.default.removeItem(atPath: outputPath)

        let models = [
            Model(name: "ModelA", properties: [Property(name: "refB", type: "ModelB")]),
            Model(name: "ModelB", properties: [Property(name: "refA", type: "ModelA")])
        ]
        XCTAssertThrowsError(try ModelGenerator.generate(models: models, outputPath: outputPath))
    }
}

