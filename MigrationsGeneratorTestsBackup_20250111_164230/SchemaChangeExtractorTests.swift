//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/SchemaChangeExtractorTests.swift
//

import XCTest

final class SchemaChangeExtractorTests: XCTestCase {
    
    func testExtractCreateTableChange() {
        let extractor = SchemaChangeExtractor()
        let changes = extractor.extractChanges(
            from: "mockTypesFileContent",
            validatedModels: [
                Model(name: "Users", columns: [
                    ColumnDefinition(name: "id", type: .uuid),
                    ColumnDefinition(name: "name", type: .text)
                ])
            ]
        )
        
        XCTAssertEqual(changes.count, 1)
        XCTAssertEqual(changes.first?.type, .createTable)
        XCTAssertEqual(changes.first?.tableName, "Users")
    }
    
    func testExtractAddColumnChange() {
        let extractor = SchemaChangeExtractor()
        let changes = extractor.extractChanges(
            from: "mockTypesFileContent",
            validatedModels: [
                Model(name: "Users", columns: [
                    ColumnDefinition(name: "age", type: .integer)
                ])
            ]
        )
        
        XCTAssertEqual(changes.count, 1)
        XCTAssertEqual(changes.first?.type, .addColumn)
        XCTAssertEqual(changes.first?.tableName, "Users")
        XCTAssertEqual(changes.first?.columns.first?.name, "age")
    }
    
    func testNoChangesDetected() {
        let extractor = SchemaChangeExtractor()
        let changes = extractor.extractChanges(
            from: "mockTypesFileContent",
            validatedModels: []
        )
        
        XCTAssertEqual(changes.count, 0)
    }
}

