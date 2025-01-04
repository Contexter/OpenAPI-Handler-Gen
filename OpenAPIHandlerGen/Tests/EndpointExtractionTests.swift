import XCTest
@testable import OpenAPIHandlerGen

final class EndpointExtractionTests: XCTestCase {

    func loadResource(named name: String, type: String) throws -> String {
        let path = Bundle.module.path(forResource: name, ofType: type)!
        return try String(contentsOfFile: path)
    }

    func testListWorkflowsEndpoint() throws {
        let server = try loadResource(named: "Server", type: "swift")
        let types = try loadResource(named: "Types", type: "swift")
        let openapi = try loadResource(named: "openapi", type: "yaml")

        let api = APIProtocol(server: server, types: types, openapi: openapi)
        let result = api.listWorkflows()
        XCTAssertNotNil(result, "List Workflows endpoint failed")
    }

    func testGetWorkflowEndpoint() throws {
        let server = try loadResource(named: "Server", type: "swift")
        let types = try loadResource(named: "Types", type: "swift")
        let openapi = try loadResource(named: "openapi", type: "yaml")

        let api = APIProtocol(server: server, types: types, openapi: openapi)
        let result = api.getWorkflow(id: "123")
        XCTAssertNotNil(result, "Get Workflow endpoint failed")
    }

    func testListWorkflowRunsEndpoint() throws {
        let server = try loadResource(named: "Server", type: "swift")
        let types = try loadResource(named: "Types", type: "swift")
        let openapi = try loadResource(named: "openapi", type: "yaml")

        let api = APIProtocol(server: server, types: types, openapi: openapi)
        let result = api.listWorkflowRuns(workflowId: "123")
        XCTAssertNotNil(result, "List Workflow Runs endpoint failed")
    }

    func testDownloadWorkflowLogsEndpoint() throws {
        let server = try loadResource(named: "Server", type: "swift")
        let types = try loadResource(named: "Types", type: "swift")
        let openapi = try loadResource(named: "openapi", type: "yaml")

        let api = APIProtocol(server: server, types: types, openapi: openapi)
        let result = api.downloadWorkflowLogs(runId: "456")
        XCTAssertNotNil(result, "Download Logs endpoint failed")
    }
}
