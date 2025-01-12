public struct Model {
    public let name: String
    public let properties: [Property]
    
    public init(name: String, properties: [Property]) {
        self.name = name
        self.properties = properties
    }
}

public struct Property {
    public let name: String
    public let type: String
    
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

