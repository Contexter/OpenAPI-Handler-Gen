/// Represents an extracted model with a name and body.
public struct ExtractedModel {
    public let name: String
    public let body: String

    public init(name: String, body: String) {
        self.name = name
        self.body = body
    }
}

// File: Tests/ModelGeneratorTests/ModelGeneratorTests.swift

import XCTest

final class ModelGeneratorTests: XCTestCase {
    func testGenerateValidModelCode() throws {
        let model = Model(
            name: "User",
            properties: [
                Property(name: "id", type: "Int"),
                Property(name: "name", type: "String")
            ]
        )
        let generatedCode = try ModelGenerator.generateCode(for: model)
        let expectedCode = """
        struct User {
            let id: Int
            let name: String
        }
        """
        XCTAssertEqual(generatedCode.trimmingCharacters(in: .whitespacesAndNewlines),
                       expectedCode.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func testInvalidModelNameThrowsError() {
        let model = Model(
            name: "123Invalid",
            properties: [
                Property(name: "id", type: "Int")
            ]
        )
        XCTAssertThrowsError(try ModelGenerator.validate(model: model)) { error in
            XCTAssertEqual(error as? ModelError, ModelError.invalidModelName("123Invalid"))
        }
    }

    func testInvalidPropertyNameThrowsError() {
        let model = Model(
            name: "ValidModel",
            properties: [
                Property(name: "123Invalid", type: "Int")
            ]
        )
        XCTAssertThrowsError(try ModelGenerator.validate(model: model)) { error in
            XCTAssertEqual(error as? ModelError, ModelError.invalidPropertyName("123Invalid"))
        }
    }

    func testInvalidPropertyTypeThrowsError() {
        let model = Model(
            name: "ValidModel",
            properties: [
                Property(name: "id", type: "123InvalidType")
            ]
        )
        XCTAssertThrowsError(try ModelGenerator.validate(model: model)) { error in
            XCTAssertEqual(error as? ModelError, ModelError.invalidPropertyType("123InvalidType"))
        }
    }

    func testValidateValidModel() throws {
        let model = Model(
            name: "ValidModel",
            properties: [
                Property(name: "id", type: "Int"),
                Property(name: "name", type: "String")
            ]
        )
        XCTAssertNoThrow(try ModelGenerator.validate(model: model))
    }
}

