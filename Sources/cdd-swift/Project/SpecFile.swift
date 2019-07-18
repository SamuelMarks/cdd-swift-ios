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
		print("UNIMPLEMENTED: insert(model)")
	}

	mutating func update(model: Model) {
		print("UNIMPLEMENTED: update(model)")
	}

	mutating func remove(model: String) {
		for (index, specModel) in self.syntax.components.schemas.enumerated() {
			if model == specModel.name {
				self.syntax.components.schemas.remove(at: index)
				print("REMOVED \(model) FROM SPEC")
			} else {
				exitWithError("critical error: could not remove \(model) from spec")
				exit(0)
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
