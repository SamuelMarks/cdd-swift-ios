//
//  Variable.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation

struct Variable: ProjectObject {
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


indirect enum Type: Equatable {
    case primitive(PrimitiveType)
    case array(Type)
    case complex(String)
}

enum PrimitiveType: String {
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
