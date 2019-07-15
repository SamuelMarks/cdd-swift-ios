import JSONUtilities

extension Path : Encodable {
	enum CodingKeys: String, CodingKey {
		case responses
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		let successResponse = [200: ["description": "success"]]
		try container.encode(successResponse, forKey: .responses)
	}
}


public struct Path {
    public let path: String
    public var operations: [Operation]
    public let parameters: [PossibleReference<Parameter>]
}

extension Path: NamedMappable {

    public init(name: String, jsonDictionary: JSONDictionary) throws {
        path = name
        parameters = (jsonDictionary.json(atKeyPath: "parameters")) ?? []

        var mappedOperations: [Operation] = []
        for (key, value) in jsonDictionary {
            if let method = Operation.Method(rawValue: key) {
                if let json = value as? [String: Any] {
                    let operation = try Operation(path: path, method: method, pathParameters: parameters, jsonDictionary: json)
                    mappedOperations.append(operation)
                }
            }
        }
        operations = mappedOperations
    }
}
