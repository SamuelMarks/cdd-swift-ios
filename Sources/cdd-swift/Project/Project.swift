//
//  Project.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation

struct Project {
	var info: ProjectInfo
	var models: [Model]
	var requests: [Request]

	func merge(with swiftProject: Project) -> Project {
		var models: [Model] = []

		for specModel in self.models {
			if case let .some(swiftModel) = specModel.find(in: swiftProject.models) {
				// model exists, merge it with the existing one
				models.append(swiftModel.merge(with: specModel))
			} else {
				// model is new, add it directly
				// for now, use spec file as source of truth in missing case
				models.append(specModel)
			}
		}

		return Project(
			info: self.info.merge(with: swiftProject.info),
			models: models,
			requests: []
		)
	}
}

struct Settings {
	let host: URL
}












