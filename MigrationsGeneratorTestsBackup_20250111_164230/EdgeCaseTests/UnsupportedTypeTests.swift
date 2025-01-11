//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/EdgeCaseTests/UnsupportedTypeTests.swift
//

import XCTest

final class UnsupportedTypeTests: XCTestCase {
    
    func testUnsupportedColumnTypeInCreateTableThrowsError() {
        let migration = CreateTableMigration(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "profile_picture", type: .unsupported)
            ]
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for unsupported column type in create table") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.unsupportedColumnType)
        }
    }
    
    func testUnsupportedColumnTypeInAddColumnThrowsError() {
        let migration = AddColumnMigration(
            tableName: "Users",
            column: ColumnDefinition(name: "preferences", type: .unsupported)
        )
        
        XCTAssertThrowsError(try migration.up(), "Expected an error for unsupported column type in add column") { error in
            XCTAssertEqual(error as? MigrationError, MigrationError.unsupportedColumnType)
        }
    }
    
    func testPartiallySupportedColumnTypeDoesNotThrowError() {
        let migration = CreateTableMigration(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "last_login", type: .text) // Assume "text" is supported
            ]
        )
        
        XCTAssertNoThrow(try migration.up(), "Expected no error for a supported column type")
    }
}

