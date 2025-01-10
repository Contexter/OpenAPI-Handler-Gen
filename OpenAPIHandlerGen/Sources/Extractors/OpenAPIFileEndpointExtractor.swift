import Foundation

public struct OpenAPIFileEndpointExtractor {
    public struct Endpoint {
        public let path: String
        public let operationId: String
    }

    public static func extractEndpoints(fromOpenAPIFile openAPIContent: [String: Any]) -> [Endpoint] {
        guard let paths = openAPIContent["paths"] as? [String: Any] else { return [] }

        var endpoints = [Endpoint]()
        let validMethods = ["get", "post", "put", "delete", "patch"]

        for (path, methods) in paths {
            guard let methodsDict = methods as? [String: Any] else { continue }

            for (method, details) in methodsDict {
                if validMethods.contains(method.lowercased()),
                   let operationId = (details as? [String: Any])?["operationId"] as? String {
                    endpoints.append(Endpoint(path: path, operationId: operationId))
                }
            }
        }

        return endpoints
    }
}
