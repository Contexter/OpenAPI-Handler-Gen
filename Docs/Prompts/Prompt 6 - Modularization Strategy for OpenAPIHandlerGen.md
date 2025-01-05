# Prompt 6 - Modularization Strategy for OpenAPIHandlerGen

## Question:
**Does it make sense to refactor the `OpenAPIHandlerGen/Sources/OpenAPIHandlerGen.swift` into one file per function or follow any other proper modularization strategy?**

---

## Decision:
Adopt **Group by Functional Modules** to provide a scalable and readable structure while avoiding excessive fragmentation.

---

## Before and After Project Structure

### **Before Modularization:**
```
Sources/
├── EndpointExtractor.swift
├── OpenAPIHandlerGen.swift
├── main.swift
```

### **After Modularization:**
```
Sources/
├── Parsers/
│   ├── YAMLParser.swift
├── Extractors/
│   ├── EndpointExtractor.swift
├── Generators/
│   ├── HandlerGenerator.swift
│   ├── ServiceGenerator.swift
├── Core/
│   ├── OpenAPIHandlerGen.swift
├── main.swift
```

---

## Modularization Tutorial

### 1. **Parsing Module**
- **File:** `Sources/Parsers/YAMLParser.swift`
- **Purpose:** Handle YAML parsing and validation.
- **Responsibilities:**
  - Read YAML files and convert them into dictionaries.
  - Validate structure and required fields.

**Example Code:**
```swift
// File: Sources/Parsers/YAMLParser.swift
import Foundation
import Yams

struct YAMLParser {
    static func parse(at path: String) throws -> [String: Any] {
        let content = try String(contentsOfFile: path, encoding: .utf8)
        let yaml = try Yams.load(yaml: content)
        guard let dictionary = yaml as? [String: Any] else {
            throw NSError(domain: "Invalid YAML Format", code: 1, userInfo: nil)
        }
        return dictionary
    }
}
```

---

### 2. **Extraction Module**
- **File:** `Sources/Extractors/EndpointExtractor.swift`
- **Purpose:** Extract endpoints, protocol methods, and type mappings.
- **Responsibilities:**
  - Parse endpoint details.
  - Extract methods and type mappings.

**Example Code:**
```swift
// File: Sources/Extractors/EndpointExtractor.swift
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
```

---

### 3. **Generation Module**
- **Files:**
  - `Sources/Generators/HandlerGenerator.swift`
  - `Sources/Generators/ServiceGenerator.swift`
- **Purpose:** Generate Swift files for handlers and services.
- **Responsibilities:**
  - Create templates based on endpoints.
  - Write files to disk.

**Handler Generator Example:**
```swift
// File: Sources/Generators/HandlerGenerator.swift
import Vapor

struct HandlerGenerator {
    static func generate(endpoint: EndpointExtractor.Endpoint, method: String, outputPath: String) {
        let template = """
        import Vapor

        struct \(method)Handler: APIProtocol {
            let service = \(method)Service()

            func \(method)(_ input: Operations.\(method).Input) async throws -> Operations.\(method).Output {
                let result = try await service.execute(input: input)
                return .ok(result)
            }
        }
        """
        let filePath = "\(outputPath)/Handlers/\(method)Handler.swift"
        try? template.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
    }
}
```

**Service Generator Example:**
```swift
// File: Sources/Generators/ServiceGenerator.swift
import Vapor

struct ServiceGenerator {
    static func generate(endpoint: EndpointExtractor.Endpoint, method: String, outputPath: String) {
        let template = """
        import Vapor

        struct \(method)Service {
            func execute(input: Operations.\(method).Input) async throws -> Operations.\(method).Output {
                return .init()
            }
        }
        """
        let filePath = "\(outputPath)/Services/\(method)Service.swift"
        try? template.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
    }
}
```

---

### 4. **Core Logic Module**
- **File:** `Sources/Core/OpenAPIHandlerGen.swift`
- **Purpose:** Serve as the orchestration layer, delegating tasks to modules.

**Example Code:**
```swift
// File: Sources/Core/OpenAPIHandlerGen.swift
import Foundation

struct OpenAPIHandlerGen {
    let openAPIPath: String
    let serverPath: String
    let typesPath: String
    let outputPath: String

    func run() throws {
        let openAPI = try YAMLParser.parse(at: openAPIPath)
        let endpoints = EndpointExtractor.extractEndpoints(from: openAPI)

        for endpoint in endpoints {
            HandlerGenerator.generate(endpoint: endpoint, method: endpoint.operationId, outputPath: outputPath)
            ServiceGenerator.generate(endpoint: endpoint, method: endpoint.operationId, outputPath: outputPath)
        }
        print("Generation complete!")
    }
}
```

---

## Next Steps
1. Split existing code into the proposed modular files.
2. Update imports and function calls to align with this structure.
3. Validate tests against the new modules and refactor as needed.
4. Commit changes with a clear message documenting the modularization process.

