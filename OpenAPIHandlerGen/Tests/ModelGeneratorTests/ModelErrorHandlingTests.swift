import XCTest
@testable import OpenAPIHandlerGen // Ensure the correct module is imported

final class ModelErrorHandlingTests: XCTestCase {
    func testInvalidModelName() {
        let invalidModel = Model(name: "123InvalidName", properties: [])
        XCTAssertThrowsError(try ModelGenerator.validateModel(invalidModel)) { error in
            guard let nsError = error as NSError? else {
                XCTFail("Expected NSError but got \(type(of: error))")
                return
            }
            XCTAssertEqual(nsError.domain, "ModelGenerator")
            XCTAssertEqual(nsError.code, 3)
            XCTAssertEqual(nsError.localizedDescription, "Model name contains invalid characters or starts with a digit.")
        }
    }

    func testInvalidPropertyName() {
        let invalidModel = Model(name: "ValidName", properties: [
            Property(name: "invalid-property", type: "String")
        ])
        XCTAssertThrowsError(try ModelGenerator.validateModel(invalidModel)) { error in
            guard let nsError = error as NSError? else {
                XCTFail("Expected NSError but got \(type(of: error))")
                return
            }
            XCTAssertEqual(nsError.domain, "ModelGenerator")
            XCTAssertEqual(nsError.code, 4)
            XCTAssertEqual(nsError.localizedDescription, "Property name contains invalid characters.")
        }
    }

    func testReservedKeywordPropertyName() {
        let invalidModel = Model(name: "ValidName", properties: [
            Property(name: "class", type: "String")
        ])
        XCTAssertThrowsError(try ModelGenerator.validateModel(invalidModel)) { error in
            guard let nsError = error as NSError? else {
                XCTFail("Expected NSError but got \(type(of: error))")
                return
            }
            XCTAssertEqual(nsError.domain, "ModelGenerator")
            XCTAssertEqual(nsError.code, 5)
            XCTAssertEqual(nsError.localizedDescription, "Property name uses a reserved keyword.")
        }
    }

    func testValidModel() {
        let validModel = Model(name: "ValidName", properties: [
            Property(name: "id", type: "String"),
            Property(name: "name", type: "String")
        ])
        XCTAssertNoThrow(try ModelGenerator.validateModel(validModel))
    }
}
