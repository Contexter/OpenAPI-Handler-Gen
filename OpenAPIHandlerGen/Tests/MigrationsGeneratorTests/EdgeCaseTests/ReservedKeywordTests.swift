//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/EdgeCaseTests/ReservedKeywordTests.swift
//

import XCTest

final class ReservedKeywordTests: XCTestCase {
    
    func testReservedKeywordInTableNameThrowsError() {
        let migration = CreateTableMigration(
            tableName: "Order",
            columns: [
                ColumnDefinition(name: "id", type: .uuid),
                ColumnDefinition(name: "name", type: .text)
            ]
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for using a reserved keyword as table name") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.reservedKeyword)
        }
    }
    
    func testReservedKeywordInColumnNameThrowsError() {
        let migration = CreateTableMigration(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "select", type: .text),
                ColumnDefinition(name: "email", type: .text)
            ]
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for using a reserved keyword as column name") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.reservedKeyword)
        }
    }
    
    func testAddingReservedKeywordAsColumnNameThrowsError() {
        let migration = AddColumnMigration(
            tableName: "Users",
            column: ColumnDefinition(name: "where", type: .integer)
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for using a reserved keyword as column name") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.reservedKeyword)
        }
    }
}

