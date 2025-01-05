import Foundation

let arguments = CommandLine.arguments
if arguments.count == 5 {
    let generator = OpenAPIHandlerGen(
        openAPIPath: arguments[1],
        serverPath: arguments[2],
        typesPath: arguments[3],
        outputPath: arguments[4]
    )
    do {
        try generator.run()
    } catch {
        print("Error: \(error)")
    }
} else {
    print("Usage: OpenAPIHandlerGen <openapi.yaml> <Server.swift> <Types.swift> <outputPath>")
}
