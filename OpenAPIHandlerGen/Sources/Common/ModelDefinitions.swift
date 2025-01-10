// File: Sources/Common/ModelDefinitions.swift

import Foundation

/// Represents a property in a model.
public struct Property {
    public let name: String
    public let type: String
}

/// Represents a model to be generated.
public struct Model {
    public let name: String
    public let properties: [Property]
}
