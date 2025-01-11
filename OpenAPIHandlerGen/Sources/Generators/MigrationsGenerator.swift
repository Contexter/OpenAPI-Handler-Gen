//
// File: OpenAPIHandlerGen/Sources/Generators/MigrationsGenerator.swift
//

import Foundation

/// Protocol that all migrations conform to
protocol Migration {
    func up() throws -> String
    func down() throws -> String
}

class MigrationsGenerator {
    private let schemaChanges: [SchemaChange]
    
    /// Initialize the generator with schema changes
    init(schemaChanges: [SchemaChange]) {
        self.schemaChanges = schemaChanges
    }
    
    /// Generate migration scripts based on schema changes
    func generateMigrations() -> [Migration] {
        return schemaChanges.map { change in
            switch change.type {
            case .createTable:
                return CreateTableMigration(
                    tableName: change.tableName,
                    columns: change.columns
                )
            case .addColumn:
                return AddColumnMigration(
                    tableName: change.tableName,
                    column: change.columns.first!
                )
            }
        }
    }
}

/// Migration to create a table
struct CreateTableMigration: Migration {
    let tableName: String
    let columns: [ColumnDefinition]
    
    func up() throws -> String {
        guard !tableName.isEmpty else { throw MigrationError.missingTableName }
        guard !columns.isEmpty else { throw MigrationError.emptyColumns }
        
        let formattedColumns = columns.map { "\($0.name) \($0.type.rawValue)" }.joined(separator: ", ")
        return "CREATE TABLE \(tableName) (\(formattedColumns));"
    }
    
    func down() throws -> String {
        guard !tableName.isEmpty else { throw MigrationError.missingTableName }
        return "DROP TABLE \(tableName);"
    }
}

/// Migration to add a column to an existing table
struct AddColumnMigration: Migration {
    let tableName: String
    let column: ColumnDefinition
    
    func up() throws -> String {
        guard !tableName.isEmpty else { throw MigrationError.missingTableName }
        guard !column.name.isEmpty else { throw MigrationError.emptyColumnName }
        return "ALTER TABLE \(tableName) ADD COLUMN \(column.name) \(column.type.rawValue);"
    }
    
    func down() throws -> String {
        guard !tableName.isEmpty else { throw MigrationError.missingTableName }
        guard !column.name.isEmpty else { throw MigrationError.emptyColumnName }
        return "ALTER TABLE \(tableName) DROP COLUMN \(column.name);"
    }
}

/// Represents a schema change (create table or add column)
struct SchemaChange {
    let type: SchemaChangeType
    let tableName: String
    let columns: [ColumnDefinition]
}

/// Represents the type of schema change
enum SchemaChangeType {
    case createTable
    case addColumn
}

/// Represents a column in a database table
struct ColumnDefinition {
    let name: String
    let type: ColumnType
}

/// Supported column types
enum ColumnType: String {
    case uuid = "UUID"
    case text = "TEXT"
    case integer = "INTEGER"
}

/// Errors related to migration generation
enum MigrationError: Error {
    case missingTableName
    case emptyColumns
    case emptyColumnName
}
