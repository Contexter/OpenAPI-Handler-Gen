//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/MigrationScriptFormatterTests.swift
//

import XCTest

final class MigrationScriptFormatterTests: XCTestCase {
    
    func testFormatCreateTableScript() {
        let formatter = MigrationScriptFormatter()
        let script = formatter.formatCreateTable(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "id", type: .uuid),
                ColumnDefinition(name: "name", type: .text),
                ColumnDefinition(name: "email", type: .text)
            ]
        )
        
        let expectedSQL = "CREATE TABLE Users (id UUID, name TEXT, email TEXT);"
        XCTAssertEqual(script, expectedSQL)
    }
    
    func testFormatAddColumnScript() {
        let formatter = MigrationScriptFormatter()
        let script = formatter.formatAddColumn(
            tableName: "Users",
            column: ColumnDefinition(name: "age", type: .integer)
        )
        
        let expectedSQL = "ALTER TABLE Users ADD COLUMN age INTEGER;"
        XCTAssertEqual(script, expectedSQL)
    }
    
    func testLongColumnDefinitionFormatsCorrectly() {
        let formatter = MigrationScriptFormatter()
        let script = formatter.formatCreateTable(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "id", type: .uuid),
                ColumnDefinition(name: "bio", type: .text),
                ColumnDefinition(name: "profile_picture_url", type: .text)
            ]
        )
        
        let expectedSQL = "CREATE TABLE Users (id UUID, bio TEXT, profile_picture_url TEXT);"
        XCTAssertEqual(script, expectedSQL)
    }
    
    func testInvalidTableNameThrowsError() {
        let formatter = MigrationScriptFormatter()
        XCTAssertThrowsError(try formatter.formatCreateTable(
            tableName: "",
            columns: [
                ColumnDefinition(name: "id", type: .uuid)
            ]
        ), "Expected an error for an invalid table name") { error in
            XCTAssertEqual(error as? FormattingError, FormattingError.invalidTableName)
        }
    }
    
    func testEmptyColumnsThrowsError() {
        let formatter = MigrationScriptFormatter()
        XCTAssertThrowsError(try formatter.formatCreateTable(
            tableName: "Users",
            columns: []
        ), "Expected an error for empty columns") { error in
            XCTAssertEqual(error as? FormattingError, FormattingError.emptyColumns)
        }
    }
}

