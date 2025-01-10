// File: Tests/ModelGeneratorTests/ModelPerformanceTests.swift

import XCTest
@testable import OpenAPIHandlerGen

/// Performance tests for the `ModelGenerator`.
final class ModelPerformanceTests: XCTestCase {

    func testLargeModelGenerationPerformance() {
        let properties = (1...1000).map { Property(name: "property\($0)", type: "String") }
        let model = Model(name: "LargeModel", properties: properties)

        measure {
            _ = ModelGenerator.generateModelContent(for: model)
        }
    }

    func testDirectoryCreationPerformance() {
        measure {
            let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("PerformanceTestModels").path
            try? ModelGenerator.generate(from: "dummyPath", outputPath: outputPath)
        }
    }
}
