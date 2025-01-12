// File: Tests/TypesFileExtractorTests/NestedStructureExtractionTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class NestedStructureExtractionTests: XCTestCase {
    func testNestedStructExtraction() throws {
        let content = """
        struct Outer {
            let id: Int

            struct Inner {
                let name: String
            }
        }
        """
        let models: [ExtractedModel]
        // Test with the existing `extractModels` method
        models = TypesFileExtractor.extractModels(from: content)

        XCTAssertEqual(models.count, 1, "Expected only the outermost struct to be extracted.")
        XCTAssertEqual(models.first?.name, "Outer")
    }
}
