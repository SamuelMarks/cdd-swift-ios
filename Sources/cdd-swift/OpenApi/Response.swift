import JSONUtilities

extension OperationResponse : Encodable {
    enum CodingKeys: String, CodingKey {
        case statusCode
    }
    
    public func encode(to encoder: Encoder) throws {
        try response.encode(to: encoder)
    }
}


public struct OperationResponse {
    public let statusCode: Int?
    public let response: PossibleReference<Response>
}

extension Response : Encodable {
    enum CodingKeys: String, CodingKey {
        case description
        case content
        case headers
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        if content != nil {
            try container.encode(content, forKey: .content)
        }
        if headers.count > 0 {
            try container.encode(headers, forKey: .headers)
        }
    }
}


public struct Response {

    public let description: String
    public let content: Content?
    public let headers: [String: PossibleReference<Header>]
}

extension Header : Encodable {
    enum CodingKeys: String, CodingKey {
        case required
        case description
        case schema
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(required, forKey: .required)
        try container.encode(description, forKey: .description)
        try container.encode(schema, forKey: .schema)
    }
}

public struct Header {

    public let description: String?
    public let required: Bool
    public let example: Any?
    public let schema: ParameterSchema
}

extension Header: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        description = jsonDictionary.json(atKeyPath: "description")
        required = (jsonDictionary.json(atKeyPath: "required")) ?? false
        example = jsonDictionary["example"]

        let schema: Schema = try jsonDictionary.json(atKeyPath: "schema")
        let serializationStyle: SerializationStyle = jsonDictionary.json(atKeyPath: "style") ?? ParameterLocation.header.defaultSerializationStyle
        let explode: Bool = jsonDictionary.json(atKeyPath: "explode") ?? serializationStyle == .form ? true : false
        self.schema = ParameterSchema(schema: schema, serializationStyle: serializationStyle, explode: explode)
    }
}

extension Response: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        description = try jsonDictionary.json(atKeyPath: "description")
        content = jsonDictionary.json(atKeyPath: "content")
        headers = jsonDictionary.json(atKeyPath: "headers") ?? [:]
    }
}
