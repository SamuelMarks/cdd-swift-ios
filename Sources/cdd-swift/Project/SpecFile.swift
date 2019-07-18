//
//  SpecFile.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation

struct SpecFile {
	let path: URL
	let modificationDate: Date
	var syntax: SwaggerSpec

	mutating func apply(projectInfo: ProjectInfo) {
		let hostname = projectInfo.hostname.absoluteString
		if !self.syntax.servers.map({$0.url}).contains(projectInfo.hostname.absoluteString) {
			self.syntax.servers.append(Server(name: nil, url: hostname, description: nil, variables: [:]))
		}
	}

	mutating func insert(model: Model) {
		let properties = SwaggerSpec.schemas(from: model.vars)
		let schema = Schema(metadata: Metadata(jsonDictionary: ["type":"object"]), type: SwaggerSpec.objectType(for: properties))
		self.syntax.components.schemas.append(ComponentObject(name: model.name, value: schema))
	}

	mutating func update(model: Model) {
		log.errorMessage("UNIMPLEMENTED: update \(model.name) in specfile")
	}

	mutating func remove(model: String) {
		for (index, specModel) in self.syntax.components.schemas.enumerated() {
			if model == specModel.name {
				self.syntax.components.schemas.remove(at: index)
				print("REMOVED \(model) FROM SPEC")
			} else {
				exitWithError("critical error: could not remove \(model) from spec")
			}
		}
	}

	func generateProject() -> Project {
		return Project.fromSwagger(self)!
	}

	func contains(model name: String) -> Bool {
		return self.syntax.components.schemas.contains(where: {$0.name == name})
	}
}

extension SwaggerSpec {
	static func schemas(from variables:[Variable]) -> [Property] {
		return variables.map({$0.property()})
	}

	static func objectType(for properties: [Property]) -> SchemaType {
		let requiredProperties = properties.filter { $0.required }
		let optionalProperties = properties.filter { !$0.required }

		return .object(ObjectSchema(requiredProperties: requiredProperties, optionalProperties: optionalProperties, properties: properties, minProperties: nil, maxProperties: nil, additionalProperties: nil, abstract: false, discriminator: nil))
	}
}
