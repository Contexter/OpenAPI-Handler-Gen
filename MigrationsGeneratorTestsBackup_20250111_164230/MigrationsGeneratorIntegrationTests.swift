//
// File: OpenAPIHandlerGen/Tests/MigrationsGeneratorTests/MigrationsGeneratorIntegrationTests.swift
//

import XCTest

final class MigrationsGeneratorIntegrationTests: XCTestCase {
    
    func testGenerateAndSaveMigrations() {
        let schemaChanges = [
            SchemaChange(
                type: .createTable,
                tableName: "Users",
                columns: [
                    ColumnDefinition(name: "id", type: .uuid),
                    ColumnDefinition(name: "name", type: .text)
                ]
            ),
            SchemaChange(
                type: .addColumn,
                tableName: "Users",
                columns: [
                    ColumnDefinition(name: "age", type: .integer)
                ]
            )
        ]
        
        let generator = MigrationsGenerator(schemaChanges: schemaChanges)
        let migrations = generator.generateMigrations()
        
        XCTAssertEqual(migrations.count, 2)
        
        // Check the generated migration scripts
        XCTAssertTrue(migrations[0].up().contains("CREATE TABLE Users"))
        XCTAssertTrue(migrations[1].up().contains("ADD COLUMN age"))
        
        // Simulate saving migrations
        let filenames = saveMigrationsToDirectory(migrations)
        XCTAssertEqual(filenames.count, 2)
        XCTAssertTrue(filenames.first?.contains("CreateUsersTable") ?? false)
    }
    
    func testIdempotentMigrations() {
        let migration = CreateTableMigration(
            tableName: "Users",
            columns: [
                ColumnDefinition(name: "id", type: .uuid),
                ColumnDefinition(name: "name", type: .text)
            ]
        )
        
        let firstRun = migration.up()
        let secondRun = migration.up()
        XCTAssertEqual(firstRun, secondRun, "Expected migrations to be idempotent")
    }
    
    func testComplexMigrationSequence() {
        let schemaChanges = [
            SchemaChange(
                type: .createTable,
                tableName: "Orders",
                columns: [
                    ColumnDefinition(name: "order_id", type: .uuid),
                    ColumnDefinition(name: "status", type: .text)
                ]
            ),
            SchemaChange(
                type: .addColumn,
                tableName: "Orders",
                columns: [
                    ColumnDefinition(name: "delivery_date", type: .text)
                ]
            ),
            SchemaChange(
                type: .addColumn,
                tableName: "Users",
                columns: [
                    ColumnDefinition(name: "last_login", type: .text)
                ]
            )
        ]
        
        let generator = MigrationsGenerator(schemaChanges: schemaChanges)
        let migrations = generator.generateMigrations()
        
        XCTAssertEqual(migrations.count, 3)
        XCTAssertTrue(migrations[0].up().contains("CREATE TABLE Orders"))
        XCTAssertTrue(migrations[1].up().contains("ADD COLUMN delivery_date"))
        XCTAssertTrue(migrations[2].up().contains("ADD COLUMN last_login"))
    }
    
    private func saveMigrationsToDirectory(_ migrations: [Migration]) -> [String] {
        // Simulated saving logic: generate filenames for migrations
        return migrations.map { migration in
            let timestamp = DateFormatter.localizedString(
                from: Date(),
                dateStyle: .short,
                timeStyle: .medium
            ).replacingOccurrences(of: "[:/\\s]", with: "", options: .regularExpression)
            return "\(timestamp)_\(type(of: migration)).swift"
        }
    }
}

