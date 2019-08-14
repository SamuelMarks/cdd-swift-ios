//
//  Variable.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation

struct Variable: ProjectObject, Codable {
	let name: String
	var optional: Bool
	var type: Type
	var value: String?
	var description: String?

	init(name: String) {
		self.name = name
		optional = false
		type = .primitive(.String)
	}

	func find(in variables: [Variable]) -> Variable? {
		return variables.first(where: {
			self.name == $0.name
		})
	}
}


indirect enum Type: Equatable, Codable {
    case primitive(PrimitiveType)
    case array(Type)
    case complex(String)
    
    enum CodingKeys: String, CodingKey {
        case array
        case primitive
        case complex
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .primitive(let type):
            try container.encode(type, forKey: .primitive)
        case .array(let type):
            try container.encode(type, forKey: .array)
        case .complex(let type):
            try container.encode(type, forKey: .complex)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let primitiveType = try? container.decode(PrimitiveType.self, forKey: .primitive)
        let arrType = try? container.decode(Type.self, forKey: .array)
        let complexType = try? container.decode(String.self, forKey: .complex)
        
        if let type = primitiveType {
            self = .primitive(type)
        } else
        if let type = arrType {
            self = .array(type)
        } else  {
            self = .complex(complexType ?? "")
        }
    }
}

enum PrimitiveType: String, Codable {
    case String
    case Int
    case Float
    case Bool
}

private extension Type {
    func schema() -> Schema {
        switch self {
        case .primitive(let type):
            var typeRaw = "string"
            var schemaType: SchemaType = .boolean
            switch type {
            case .Int:
                typeRaw = "integer"
                schemaType = .integer(IntegerSchema(jsonDictionary: [:]))
            case .Float:
                typeRaw = "number"
                schemaType = .number(NumberSchema(jsonDictionary: [:]))
            case .Bool:
                typeRaw = "boolean"
                schemaType = .boolean
            case .String:
                typeRaw = "string"
                schemaType = .string(StringSchema(jsonDictionary: [:]))
            }
            return Schema(metadata: Metadata(jsonDictionary: ["type":typeRaw]), type: schemaType)
        case .array(let type):
            let itemSchema = type.schema()
            let arrSchema = ArraySchema(items: .single(itemSchema), minItems: nil, maxItems: nil, additionalItems: nil, uniqueItems: false)
            return Schema(metadata: Metadata(jsonDictionary: ["type":"array"]), type: .array(arrSchema))
        case .complex(let objectName):
            
            return Schema(metadata: Metadata(jsonDictionary: ["type":"object"]), type: .reference(Reference("#/components/schemas/" + objectName)))
        }
    }
}


extension Variable {
    func property() -> Property {
        return Property(name: name, required: !optional, schema: type.schema())
    }
    func parameter() -> Parameter {
        let parType = ParameterType.schema(ParameterSchema(schema: type.schema(), serializationStyle: .simple, explode: false))
        return Parameter(name: name, location: .query, description: description, required: !optional, example: nil, type: parType, json: [:])
    }
}
