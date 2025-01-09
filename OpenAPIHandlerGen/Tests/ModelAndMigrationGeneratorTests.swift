// File: OpenAPIHandlerGen/Tests/ModelAndMigrationGeneratorTests.swift

import XCTest
@testable import OpenAPIHandlerGen

final class ModelAndMigrationGeneratorTests: XCTestCase {

    var tempOutputPath: String!

    override func setUp() {
        super.setUp()
        tempOutputPath = NSTemporaryDirectory() + "TestOutput"
        try? FileManager.default.removeItem(atPath: tempOutputPath)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(atPath: tempOutputPath)
        super.tearDown()
    }

    // Test 1: Basic Directory Creation
    func testBasicDirectoryCreation() throws {
        let types: [TypeDefinition] = []

        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)

        XCTAssertTrue(FileManager.default.fileExists(atPath: tempOutputPath + "/Models"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: tempOutputPath + "/Migrations"))
    }

    // Test 2: Basic Model Generation
    func testModelGeneration() throws {
        let types = [
            TypeDefinition(name: "User", fields: [
                Field(name: "id", type: "UUID"),
                Field(name: "name", type: "String"),
                Field(name: "email", type: "String?")
            ])
        ]

        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)

        let modelPath = tempOutputPath + "/Models/User.swift"
        XCTAssertTrue(FileManager.default.fileExists(atPath: modelPath))

        let content = try String(contentsOfFile: modelPath)
        XCTAssertTrue(content.contains("struct User: Codable"))
        XCTAssertTrue(content.contains("let id: UUID"))
        XCTAssertTrue(content.contains("let email: String?"))
    }

    // Test 3: Basic Migration Generation
    func testMigrationGeneration() throws {
        let types = [
            TypeDefinition(name: "User", fields: [
                Field(name: "id", type: "UUID"),
                Field(name: "name", type: "String"),
                Field(name: "email", type: "String?")
            ])
        ]

        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)

        let migrationPath = tempOutputPath + "/Migrations/CreateUser.swift"
        XCTAssertTrue(FileManager.default.fileExists(atPath: migrationPath))

        let content = try String(contentsOfFile: migrationPath)
        XCTAssertTrue(content.contains("database.schema(\"users\")"))
        XCTAssertTrue(content.contains(".field(\"email\", .string)")) // Optional field
    }

    // Test 4: belongsTo Relationship
    func testBelongsToRelationship() throws {
        let types = [
            TypeDefinition(name: "Comment", fields: [
                Field(name: "id", type: "UUID"),
                Field(name: "content", type: "String"),
                Field(name: "postID", type: "UUID")
            ])
        ]

        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)

        let migrationPath = tempOutputPath + "/Migrations/CreateComment.swift"
        XCTAssertTrue(FileManager.default.fileExists(atPath: migrationPath))

        let content = try String(contentsOfFile: migrationPath)
        XCTAssertTrue(content.contains(".field(\"postID\", .uuid, .required, .references(\"posts\", \"id\"))"))
    }

    // Test 5: hasMany Relationship
    func testHasManyRelationship() throws {
        let types = [
            TypeDefinition(name: "User", fields: [
                Field(name: "id", type: "UUID")
            ]),
            TypeDefinition(name: "Order", fields: [
                Field(name: "id", type: "UUID"),
                Field(name: "userID", type: "UUID")
            ])
        ]

        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)

        let userModelFilePath = tempOutputPath + "/Models/User.swift"
        let userModelContent = try String(contentsOfFile: userModelFilePath)
        XCTAssertTrue(userModelContent.contains("let orders: [Order]"))

        let orderMigrationPath = tempOutputPath + "/Migrations/CreateOrder.swift"
        let orderMigrationContent = try String(contentsOfFile: orderMigrationPath)
        XCTAssertTrue(orderMigrationContent.contains(".field(\"userID\", .uuid, .required, .references(\"users\", \"id\"))"))
    }

    // Test 6: hasOne Relationship
    func testHasOneRelationship() throws {
        let types = [
            TypeDefinition(name: "User", fields: [
                Field(name: "id", type: "UUID"),
                Field(name: "profileID", type: "UUID")
            ]),
            TypeDefinition(name: "Profile", fields: [
                Field(name: "id", type: "UUID"),
                Field(name: "bio", type: "String")
            ])
        ]

        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)

        let userModelFilePath = tempOutputPath + "/Models/User.swift"
        let userModelContent = try String(contentsOfFile: userModelFilePath)
        XCTAssertTrue(userModelContent.contains("let profile: Profile?"))
    }

    // Test 7: Field Constraints (unique, indexed)
    func testFieldConstraints() throws {
        let types = [
            TypeDefinition(name: "User", fields: [
                Field(name: "id", type: "UUID"),
                Field(name: "email", type: "String", constraints: ["unique"]),
                Field(name: "createdAt", type: "Date", constraints: ["indexed"])
            ])
        ]

        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)

        let migrationFilePath = tempOutputPath + "/Migrations/CreateUser.swift"
        let content = try String(contentsOfFile: migrationFilePath)
        XCTAssertTrue(content.contains(".unique(on: \"email\")"))
        XCTAssertTrue(content.contains(".index(\"createdAt\")"))
    }

    // Test 8: Empty Schema Handling
    func testEmptySchema() throws {
        let types: [TypeDefinition] = []

        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)

        XCTAssertFalse(FileManager.default.fileExists(atPath: tempOutputPath + "/Models"))
        XCTAssertFalse(FileManager.default.fileExists(atPath: tempOutputPath + "/Migrations"))
    }

    // Test 9: Large Schema Performance
    func testLargeSchemaPerformance() throws {
        var fields = [Field(name: "id", type: "UUID")]
        for i in 1...500 {
            fields.append(Field(name: "field\(i)", type: "String"))
        }

        let types = [
            TypeDefinition(name: "LargeModel", fields: fields)
        ]

        let startTime = CFAbsoluteTimeGetCurrent()
        try ModelAndMigrationGenerator.generate(types: types, outputPath: tempOutputPath)
        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime

        XCTAssertTrue(elapsedTime < 2.0, "Generator took too long for large schema")
    }
}
