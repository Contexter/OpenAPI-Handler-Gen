// File: Tests/ModelGeneratorTests/ModelContentValidationTests.swift

import XCTest
@testable import OpenAPIHandlerGen

/// Tests for model content validation.
final class ModelContentValidationTests: XCTestCase {

    func testValidModelContentGeneration() {
        let model = Model(name: "User", properties: [
            Property(name: "id", type: "Int"),
            Property(name: "name", type: "String")
        ])
        let content = ModelGenerator.generateModelContent(for: model)
        XCTAssertTrue(content.contains("struct User"))
        XCTAssertTrue(content.contains("let id: Int"))
        XCTAssertTrue(content.contains("let name: String"))
    }

    func testEmptyModelValidation() throws {
        let model = Model(name: "Empty", properties: [])
        XCTAssertNoThrow(try ModelGenerator.validateModel(model))
    }

    func testInvalidPropertyNames() throws {
        let model = Model(name: "User", properties: [
            Property(name: "invalid-property", type: "String")
        ])
        XCTAssertThrowsError(try ModelGenerator.validateModel(model)) { error in
            XCTAssertTrue("\(error)".contains("Property name contains invalid characters"))
        }
    }
}
