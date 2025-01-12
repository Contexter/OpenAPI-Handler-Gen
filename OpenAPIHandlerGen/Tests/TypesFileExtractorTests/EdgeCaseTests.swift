// File: Tests/TypesFileExtractorTests/EdgeCaseTests.swift
import XCTest
@testable import OpenAPIHandlerGen // Import the module

/// Tests for edge cases in TypesFileExtractor.
final class EdgeCaseTests: XCTestCase {
    func testFileWithComplexSpacing() {
        let content = """
        struct    ComplexModel  { let id: Int }
        """
        let models = TypesFileExtractor.extractModels(from: content)
        XCTAssertEqual(models.count, 1, "Expected 1 model to be extracted from a file with complex spacing.")
        XCTAssertEqual(models.first?.name, "ComplexModel")
    }
}
