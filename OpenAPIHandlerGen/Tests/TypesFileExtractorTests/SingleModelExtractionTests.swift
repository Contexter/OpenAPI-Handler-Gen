// File: Tests/TypesFileExtractorTests/SingleModelExtractionTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class SingleModelExtractionTests: XCTestCase {

    func testSingleModelExtraction() {
        let content = """
        struct User {
            let id: Int
            let name: String
        }
        """
        let models = TypesFileExtractor.extractModels(from: content)
        XCTAssertEqual(models.count, 1, "Expected 1 model to be extracted.")
        XCTAssertEqual(models[0].name, "User", "Extracted model name is incorrect.")
    }
}

