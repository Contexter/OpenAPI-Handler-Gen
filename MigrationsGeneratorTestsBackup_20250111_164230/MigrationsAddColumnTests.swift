//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/MigrationsAddColumnTests.swift
//

import XCTest

final class MigrationsAddColumnTests: XCTestCase {
    
    func testUpGeneratesAddColumnStatement() {
        let migration = AddColumnMigration(
            tableName: "Users",
            column: ColumnDefinition(name: "age", type: .integer)
        )
        
        let expectedSQL = "ALTER TABLE Users ADD COLUMN age INTEGER;"
        XCTAssertEqual(migration.up(), expectedSQL)
    }
    
    func testDownGeneratesDropColumnStatement() {
        let migration = AddColumnMigration(
            tableName: "Users",
            column: ColumnDefinition(name: "age", type: .integer)
        )
        
        let expectedSQL = "ALTER TABLE Users DROP COLUMN age;"
        XCTAssertEqual(migration.down(), expectedSQL)
    }
    
    func testMissingTableNameThrowsError() {
        XCTAssertThrowsError(try AddColumnMigration(
            tableName: "",
            column: ColumnDefinition(name: "age", type: .integer)
        ).up(), "Expected an error when attempting to add a column to a table with no name") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.missingTableName)
        }
    }
    
    func testEmptyColumnThrowsError() {
        XCTAssertThrowsError(try AddColumnMigration(
            tableName: "Users",
            column: ColumnDefinition(name: "", type: .integer)
        ).up(), "Expected an error when attempting to add a column with no name") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.emptyColumnName)
        }
    }
}

