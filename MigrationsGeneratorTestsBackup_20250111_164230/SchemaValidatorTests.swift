//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/SchemaValidatorTests.swift
//

import XCTest

final class SchemaValidatorTests: XCTestCase {
    
    func testValidSchemaChange() {
        let validator = SchemaValidator()
        let isValid = validator.validateSchemaChange(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "id", type: .uuid),
                ColumnDefinition(name: "name", type: .text)
            ]
        )
        XCTAssertTrue(isValid)
    }
    
    func testInvalidTableNameThrowsError() {
        let validator = SchemaValidator()
        XCTAssertThrowsError(try validator.validateSchemaChange(
            tableName: "",
            columns: [
                ColumnDefinition(name: "id", type: .uuid)
            ]
        ), "Expected an error for missing table name") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.missingTableName)
        }
    }
    
    func testReservedKeywordInTableNameThrowsError() {
        let validator = SchemaValidator()
        XCTAssertThrowsError(try validator.validateSchemaChange(
            tableName: "Order",
            columns: [
                ColumnDefinition(name: "id", type: .uuid)
            ]
        ), "Expected an error for using a reserved keyword as table name") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.reservedKeyword)
        }
    }
    
    func testInvalidColumnNameThrowsError() {
        let validator = SchemaValidator()
        XCTAssertThrowsError(try validator.validateSchemaChange(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "", type: .uuid)
            ]
        ), "Expected an error for missing column name") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.emptyColumnName)
        }
    }
    
    func testUnsupportedColumnTypeThrowsError() {
        let validator = SchemaValidator()
        XCTAssertThrowsError(try validator.validateSchemaChange(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "profile_picture", type: .unsupported)
            ]
        ), "Expected an error for unsupported column type") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.unsupportedColumnType)
        }
    }
}

