import XCTest

final class InlineCodeTests: XCTestCase {

    struct MockAPI {
        func listWorkflows() -> [String] {
            return ["Workflow1", "Workflow2"]
        }

        func getWorkflow(id: String) -> String? {
            return id == "123" ? "Workflow123" : nil
        }

        func listWorkflowRuns(workflowId: String) -> [String] {
            return workflowId == "123" ? ["Run1", "Run2"] : []
        }

        func downloadWorkflowLogs(runId: String) -> String? {
            return runId == "456" ? "Logs for run 456" : nil
        }
    }

    let api = MockAPI()

    func testListWorkflows() {
        let result = api.listWorkflows()
        XCTAssertEqual(result.count, 2)
    }

    func testGetWorkflow() {
        let result = api.getWorkflow(id: "123")
        XCTAssertEqual(result, "Workflow123")
    }

    func testListWorkflowRuns() {
        let result = api.listWorkflowRuns(workflowId: "123")
        XCTAssertEqual(result.count, 2)
    }

    func testDownloadWorkflowLogs() {
        let result = api.downloadWorkflowLogs(runId: "456")
        XCTAssertEqual(result, "Logs for run 456")
    }
}
