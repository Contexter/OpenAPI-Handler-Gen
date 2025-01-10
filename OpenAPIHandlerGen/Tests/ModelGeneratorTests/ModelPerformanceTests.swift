// File: Tests/ModelGeneratorTests/ModelPerformanceTests.swift

import XCTest

final class ModelPerformanceTests: XCTestCase {

    func testDeeplyNestedPropertiesPerformance() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("TestModels").path
        try? FileManager.default.removeItem(atPath: outputPath)

        let nestedProperties = (1...100).map { index in
            Property(name: "level\(index)", type: "NestedModel\(index)")
        }
        let models = [Model(name: "RootModel", properties: nestedProperties)]

        measure {
            XCTAssertNoThrow(try ModelGenerator.generate(models: models, outputPath: outputPath))
        }
    }

    func testConcurrentFileGeneration() throws {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("ConcurrentModels").path
        try? FileManager.default.removeItem(atPath: outputPath)

        let models = (1...100).map { index in
            Model(name: "Model\(index)", properties: [
                Property(name: "id", type: "Int"),
                Property(name: "value", type: "String")
            ])
        }

        measure {
            DispatchQueue.concurrentPerform(iterations: models.count) { index in
                XCTAssertNoThrow(try ModelGenerator.generate(models: [models[index]], outputPath: outputPath))
            }
        }
    }
}

