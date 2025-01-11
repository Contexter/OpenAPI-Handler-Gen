//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/EdgeCaseTests/InvalidSchemaTests.swift
//

import XCTest

final class InvalidSchemaTests: XCTestCase {
    
    func testMissingTableNameThrowsError() {
        let migration = CreateTableMigration(
            tableName: "",
            columns: [
                ColumnDefinition(name: "id", type: .uuid),
                ColumnDefinition(name: "name", type: .text)
            ]
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for missing table name") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.missingTableName)
        }
    }
    
    func testEmptyColumnsThrowsError() {
        let migration = CreateTableMigration(
            tableName: "Users",
            columns: []
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for empty columns") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.emptyColumns)
        }
    }
    
    func testAddingColumnWithEmptyNameThrowsError() {
        let migration = AddColumnMigration(
            tableName: "Users",
            column: ColumnDefinition(name: "", type: .integer)
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for empty column name") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.emptyColumnName)
        }
    }
    
    func testAddingColumnToMissingTableThrowsError() {
        let migration = AddColumnMigration(
            tableName: "",
            column: ColumnDefinition(name: "age", type: .integer)
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for missing table name") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.missingTableName)
        }
    }
}

