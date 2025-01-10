import XCTest
@testable import OpenAPIHandlerGen

final class TypesFileExtractorTests: XCTestCase {
    func testExtractSimpleStruct() {
        let content = """
        struct User {
            var id: Int
            var name: String
        }
        """
        let models = TypesFileExtractor.parseModels(from: content)
        XCTAssertEqual(models.count, 1, "Expected 1 model to be extracted.")
        XCTAssertEqual(models[0].name, "User")
        XCTAssertEqual(models[0].fields, [
            "id": "Int",
            "name": "String"
        ])
    }

    func testExtractComplexFields() {
        let content = """
        struct Complex {
            var tupleField: (Int, String)
            var arrayField: [String]
            var dictionaryField: [String: Int]
            var optionalField: Int?
        }
        """
        let models = TypesFileExtractor.parseModels(from: content)
        XCTAssertEqual(models.count, 1, "Expected 1 model to be extracted.")
        XCTAssertEqual(models[0].name, "Complex")
        XCTAssertEqual(models[0].fields, [
            "tupleField": "(Int, String)",
            "arrayField": "[String]",
            "dictionaryField": "[String: Int]",
            "optionalField": "Int?"
        ])
    }

    func testExtractNestedStructs() {
        let content = """
        struct Outer {
            var id: Int
            struct Inner {
                var value: String
            }
        }
        """
        let models = TypesFileExtractor.parseModels(from: content)
        XCTAssertEqual(models.count, 1, "Expected 1 model to be extracted.")
        XCTAssertEqual(models[0].name, "Outer")
        XCTAssertEqual(models[0].fields, [
            "id": "Int"
        ])
    }

    func testExtractWithModifiers() {
        let content = """
        struct Modifiers {
            static var staticField: Bool
            public var publicField: String
            private var privateField: Int
        }
        """
        let models = TypesFileExtractor.parseModels(from: content)
        XCTAssertEqual(models.count, 1, "Expected 1 model to be extracted.")
        XCTAssertEqual(models[0].fields, [
            "staticField": "Bool",
            "publicField": "String",
            "privateField": "Int"
        ])
    }

    func testMalformedStruct() {
        let content = """
            struct Malformed {
                var name:
        """
        let models = TypesFileExtractor.parseModels(from: content)
        XCTAssertTrue(models.isEmpty, "Expected no models to be extracted from malformed content.")
    }

    func testEmptyContent() {
        let content = ""
        let models = TypesFileExtractor.parseModels(from: content)
        XCTAssertTrue(models.isEmpty, "Expected no models to be extracted from empty content.")
    }

    func testLargeFilePerformance() {
        let content = (1...1000).map { """
        struct Model\($0) {
            var id: Int
            var name: String
        }
        """ }.joined(separator: "\n")
        
        measure {
            let models = TypesFileExtractor.parseModels(from: content)
            XCTAssertEqual(models.count, 1000, "Expected 1000 models to be extracted.")
        }
    }

    func testRealWorldExample() {
        let content = """
        struct User {
            var id: UUID
            var name: String
            var email: String?
            var posts: [Post]
        }
        
        struct Post {
            var id: UUID
            var title: String
            var author: User
            var content: String
        }
        """
        let models = TypesFileExtractor.parseModels(from: content)
        XCTAssertEqual(models.count, 2, "Expected 2 models to be extracted.")
        XCTAssertEqual(models[0].name, "User")
        XCTAssertEqual(models[0].fields, [
            "id": "UUID",
            "name": "String",
            "email": "String?",
            "posts": "[Post]"
        ])
        XCTAssertEqual(models[1].name, "Post")
        XCTAssertEqual(models[1].fields, [
            "id": "UUID",
            "title": "String",
            "author": "User",
            "content": "String"
        ])
    }
}
