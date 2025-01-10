// File: Tests/TypesFileExtractorTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class TypesFileExtractorTests: XCTestCase {
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

    func testMultipleModelExtraction() {
        let content = """
        struct User {
            let id: Int
            let name: String
        }
        struct Product {
            let id: Int
            let title: String
        }
        """
        let models = TypesFileExtractor.extractModels(from: content)
        XCTAssertEqual(models.count, 2, "Expected 2 models to be extracted.")
        XCTAssertEqual(models[0].name, "User", "First model name is incorrect.")
        XCTAssertEqual(models[1].name, "Product", "Second model name is incorrect.")
    }
}
