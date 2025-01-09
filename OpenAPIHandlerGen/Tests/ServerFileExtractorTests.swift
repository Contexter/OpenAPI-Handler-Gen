import XCTest
@testable import OpenAPIHandlerGen

final class ServerFileExtractorTests: XCTestCase {

    func testExtractRoutesFromValidContent() {
        let simulatedServerFileContent = """
        try transport.register(
            {
                try await server.listWorkflows(
                    request: $0,
                    body: $1,
                    metadata: $2
                )
            },
            method: .get,
            path: server.apiPathComponentsWithServerPrefix("/repos/{owner}/{repo}/actions/workflows")
        )
        try transport.register(
            {
                try await server.getWorkflow(
                    request: $0,
                    body: $1,
                    metadata: $2
                )
            },
            method: .get,
            path: server.apiPathComponentsWithServerPrefix("/repos/{owner}/{repo}/actions/workflows/{workflow_id}")
        )
        """

        let routes = ServerFileExtractor.parseRoutes(from: simulatedServerFileContent)

        XCTAssertEqual(routes.count, 2, "Expected 2 routes to be extracted.")

        XCTAssertEqual(routes[0].method, "GET")
        XCTAssertEqual(routes[0].path, "/repos/{owner}/{repo}/actions/workflows")
        XCTAssertEqual(routes[0].handler, "listWorkflows")

        XCTAssertEqual(routes[1].method, "GET")
        XCTAssertEqual(routes[1].path, "/repos/{owner}/{repo}/actions/workflows/{workflow_id}")
        XCTAssertEqual(routes[1].handler, "getWorkflow")
    }

    func testExtractRoutesFromEmptyContent() {
        let simulatedEmptyContent = ""
        let routes = ServerFileExtractor.parseRoutes(from: simulatedEmptyContent)
        XCTAssertTrue(routes.isEmpty, "Expected no routes to be extracted from empty content.")
    }

    func testExtractRoutesFromInvalidContent() {
        let simulatedInvalidContent = """
        Some random text that does not match any handler registration
        Another line of text
        """

        let routes = ServerFileExtractor.parseRoutes(from: simulatedInvalidContent)
        XCTAssertTrue(routes.isEmpty, "Expected no routes to be extracted from invalid content.")
    }

    func testExtractRoutesFromMixedContent() {
        let simulatedMixedContent = """
        try transport.register(
            {
                try await server.listWorkflows(
                    request: $0,
                    body: $1,
                    metadata: $2
                )
            },
            method: .get,
            path: server.apiPathComponentsWithServerPrefix("/repos/{owner}/{repo}/actions/workflows")
        )
        Some random unrelated text
        try transport.register(
            {
                try await server.getWorkflow(
                    request: $0,
                    body: $1,
                    metadata: $2
                )
            },
            method: .get,
            path: server.apiPathComponentsWithServerPrefix("/repos/{owner}/{repo}/actions/workflows/{workflow_id}")
        )
        """

        let routes = ServerFileExtractor.parseRoutes(from: simulatedMixedContent)
        XCTAssertEqual(routes.count, 2, "Expected 2 routes to be extracted from mixed content.")

        XCTAssertEqual(routes[0].method, "GET")
        XCTAssertEqual(routes[0].path, "/repos/{owner}/{repo}/actions/workflows")
        XCTAssertEqual(routes[0].handler, "listWorkflows")

        XCTAssertEqual(routes[1].method, "GET")
        XCTAssertEqual(routes[1].path, "/repos/{owner}/{repo}/actions/workflows/{workflow_id}")
        XCTAssertEqual(routes[1].handler, "getWorkflow")
    }
}
