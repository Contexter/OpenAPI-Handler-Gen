import Foundation

public struct EndpointExtractor {
    public struct Endpoint {
        public let path: String
        public let method: String
        public let operationId: String
    }

    public static func extractEndpoints(from yaml: [String: Any]) -> [Endpoint] {
        var endpoints: [Endpoint] = []
        if let paths = yaml["paths"] as? [String: Any] {
            for (path, methods) in paths {
                guard let methodsDict = methods as? [String: Any] else { continue }
                for (method, details) in methodsDict {
                    if let detailsDict = details as? [String: Any],
                       let operationId = detailsDict["operationId"] as? String {
                        endpoints.append(
                            Endpoint(path: path, method: method.uppercased(), operationId: operationId)
                        )
                    }
                }
            }
        }
        return endpoints
    }
}
