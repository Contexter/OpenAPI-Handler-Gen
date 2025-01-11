//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/MigrationsCreateTableTests.swift
//

import XCTest

final class MigrationsCreateTableTests: XCTestCase {
    
    func testUpGeneratesCreateTableStatement() {
        let migration = CreateTableMigration(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "id", type: .uuid),
                ColumnDefinition(name: "name", type: .text),
                ColumnDefinition(name: "email", type: .text)
            ]
        )
        
        let expectedSQL = "CREATE TABLE Users (id UUID, name TEXT, email TEXT);"
        XCTAssertEqual(migration.up(), expectedSQL)
    }
    
    func testDownGeneratesDropTableStatement() {
        let migration = CreateTableMigration(
            tableName: "Users",
            columns: []
        )
        
        let expectedSQL = "DROP TABLE Users;"
        XCTAssertEqual(migration.down(), expectedSQL)
    }
    
    func testEmptyColumnsThrowsError() {
        XCTAssertThrowsError(try CreateTableMigration(
            tableName: "Users",
            columns: []
        ).up(), "Expected an error when attempting to create a table with no columns") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.emptyColumns)
        }
    }
}

