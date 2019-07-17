//
//  Changes.swift
//  CYaml
//
//  Created by Rob Saunders on 7/15/19.
//

import Foundation

enum ChangeResult {
	case success(String)
	case failure(String)
}

extension Change {
	func apply() -> ChangeResult {
		switch self {
		case .insertion(_):
			return .success("done")
		case .deletion(_):
			return .success("done")
		case .update(let update):
			return update.apply()
		}
	}
}

extension APIObjectChange {
	func apply() -> ChangeResult {
		switch self {
		case .model(let model, let modelChange):
			
			return .success("Updated \(model) with \(String(describing: modelChange))")
		case .request(let request, let requestChange):
//			request.update(requestChange)
			return .success("Updated \(request) with \(String(describing: requestChange))")
		}
	}
}

// remove below

enum VariableChange {
	case type(Type)
	case value(String?)
	case optional(Bool)
}

enum Change {
	case insertion(APIObjectChange)
	case deletion(APIObjectChange)
	case update(APIObjectChange)
}

enum APIObjectChange {
	case model(Model,ModelChange?)
	case request(Request,RequestChange?)
}

enum ModelChange {
	case deletion(Variable)
	case insertion(Variable)
	case update(String, [VariableChange])
}

enum RequestChange {
	case deletion(Variable)
	case insertion(Variable)
	case update(String, [VariableChange])
	case responseType(String)
	case errorType(String)
	case path(String)
	case method(Method)
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

extension Project {

	func compare(_ oldProject: Project) -> [Change] {
		let project = self
		var projectChanges: [Change] = []
		let models = project.models
		var oldModels = oldProject.models

		for model in models {
			if let index = oldModels.firstIndex(where: {$0.name == model.name}) {
				let oldModel = oldModels[index]
				let changes = model.compare(to: oldModel)
				if changes.count > 0 {
					projectChanges.append(contentsOf: changes.map { .update(.model(model, $0))})
				}
				oldModels.remove(at: index)

			}
			else {
				projectChanges.append(.insertion(.model(model, nil)))
			}

		}
		projectChanges.append(contentsOf:oldModels.map {Change.deletion(.model($0,nil))})

		let requests = project.requests
		var oldRequests = oldProject.requests
		for request in requests {
			if let index = oldRequests.firstIndex(where: {$0.name == request.name}) {
				let oldRequest = oldRequests[index]
				let changes = request.compare(to: oldRequest)
				if changes.count > 0 {
					projectChanges.append(contentsOf: changes.map { .update(.request(request, $0))})
				}
				oldRequests.remove(at: index)
			}
			else {
				projectChanges.append(.insertion(.request(request, nil)))
			}
		}
		projectChanges.append(contentsOf:oldRequests.map {Change.deletion(.request($0,nil))})
		return projectChanges
	}


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
			return Schema(metadata: Metadata(jsonDictionary: ["type":"object"]), type: .reference(Reference("$ref: \"#/components/schemas/" + objectName + "\"")))
		}
	}
}


private extension Variable {
	func property() -> Property {
		return Property(name: name, required: !optional, schema: type.schema())
	}
	func parameter() -> Parameter {
		let parType = ParameterType.schema(ParameterSchema(schema: type.schema(), serializationStyle: .simple, explode: false))
		return Parameter(name: name, location: .query, description: description, required: !optional, example: nil, type: parType, json: [:])
	}
}
