import Foundation
import JSONUtilities

extension RequestBody : Encodable {
    enum CodingKeys: String, CodingKey {
        case required
        case description
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(required, forKey: .required)
        try container.encode(description, forKey: .description)
    }
}

public struct RequestBody {

    public let required: Bool
    public let description: String?
    public let content: Content
}

extension RequestBody: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        required = jsonDictionary.json(atKeyPath: "required") ?? false
        description = jsonDictionary.json(atKeyPath: "description")
        content = try jsonDictionary.json(atKeyPath: "content")
    }
}
