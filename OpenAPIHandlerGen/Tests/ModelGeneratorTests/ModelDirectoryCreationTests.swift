import XCTest
@testable import OpenAPIHandlerGen

final class ModelDirectoryCreationTests: XCTestCase {
    func testDirectoryCreation() {
        let validModel = Model(name: "ValidModel", properties: [
            Property(name: "id", type: "String"),
            Property(name: "name", type: "String")
        ])
        
        do {
            let result = try ModelGenerator.createDirectory(for: validModel)
            XCTAssertTrue(FileManager.default.fileExists(atPath: result), "Directory should be created successfully.")
        } catch {
            XCTFail("Expected no error, but got: \(error)")
        }
    }

    func testDirectoryExistsValidation() {
        let validModel = Model(name: "ValidModel", properties: [
            Property(name: "id", type: "String"),
            Property(name: "name", type: "String")
        ])
        
        // Simulate the directory already existing
        let directoryPath = "path/to/directory/ValidModel"
        try? FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        
        do {
            let result = try ModelGenerator.createDirectory(for: validModel)
            XCTAssertEqual(result, directoryPath, "The directory path should match the existing one.")
        } catch {
            XCTFail("Expected no error, but got: \(error)")
        }
    }
}
