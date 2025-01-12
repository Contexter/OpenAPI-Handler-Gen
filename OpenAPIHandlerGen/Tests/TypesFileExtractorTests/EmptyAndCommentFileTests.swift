// File: Tests/TypesFileExtractorTests/EmptyAndCommentFileTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class EmptyAndCommentFileTests: XCTestCase {

    func testEmptyFileExtraction() {
        let content = ""
        let models = TypesFileExtractor.extractModels(from: content)
        XCTAssertEqual(models.count, 0, "Expected no models to be extracted from an empty file.")
    }

    func testCommentOnlyFileExtraction() {
        let content = """
        // This is a comment
        // Another comment line
        """
        let models = TypesFileExtractor.extractModels(from: content)
        XCTAssertEqual(models.count, 0, "Expected no models to be extracted from a comment-only file.")
    }
}

