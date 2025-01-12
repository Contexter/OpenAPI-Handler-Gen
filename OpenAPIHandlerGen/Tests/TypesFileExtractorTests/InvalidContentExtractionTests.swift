// File: Tests/TypesFileExtractorTests/InvalidContentExtractionTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class InvalidContentExtractionTests: XCTestCase {

    func testInvalidContentExtraction() {
        let content = """
        invalid syntax {
            not valid
        """
        let models = TypesFileExtractor.extractModels(from: content)
        XCTAssertEqual(models.count, 0, "Expected no models to be extracted from invalid content.")
    }
}

