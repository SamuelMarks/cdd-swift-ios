import JSONUtilities


extension Metadata : Encodable {
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        //need to finish
        if type == nil {
            
        }
    }
}

public struct Metadata {
    public let type: DataType?
    public let title: String?
    public let description: String?
    public let defaultValue: Any?
    public let enumValues: [Any]?
    public let enumNames: [String]?
    public let nullable: Bool
    public let example: Any?
    public var json: JSONDictionary

    init() {
        type = nil
        title = nil
        description = nil
        defaultValue = nil
        enumValues = nil
        enumNames = nil
        nullable = false
        example = nil
        json = [:]
    }
}

extension Metadata: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) {
        type = DataType(jsonDictionary: jsonDictionary)
        title = jsonDictionary.json(atKeyPath: "title")
        description = jsonDictionary.json(atKeyPath: "description")
        defaultValue = jsonDictionary["default"]
        enumValues = jsonDictionary["enum"] as? [Any]
        enumNames = jsonDictionary["x-enum-names"] as? [String]
        nullable = (jsonDictionary.json(atKeyPath: "x-nullable")) ?? false
        example = jsonDictionary["example"]
        json = jsonDictionary
    }
}
