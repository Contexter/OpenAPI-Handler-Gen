// File: Tests/TypesFileExtractorTests/MultipleModelExtractionTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class MultipleModelExtractionTests: XCTestCase {
    func testMultipleModelExtraction() throws {
        let content = """
        struct ModelA {
            let id: Int
        }

        struct ModelB {
            let name: String
        }
        """
        let models = TypesFileExtractor.extractModels(from: content)
        XCTAssertEqual(models.count, 2, "Expected 2 models to be extracted.")
        XCTAssertEqual(models[0].name, "ModelA")
        XCTAssertEqual(models[1].name, "ModelB")
    }
}
