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

		for swiftModel in swiftProject.models {
			// check for model in the spec
			if case let .some(specModel) = swiftModel.find(in: self.models) {
				// model exists, decide on most recent one.
				models.append(Model.newest(swiftModel, specModel))
			} else {
				// not there, but is the spec file newer than this file?
				if self.info.modificationDate.compare(swiftModel.modificationDate) == .orderedDescending {
					// yes, so delete it (eg. skip it)
				} else {
					// nope, so it's valid and new, add it
					models.append(swiftModel)
				}
			}
		}

		// now search the spec file
		for specModel in self.models {
			// if we haven't compared this already,
			if !(specModel.find(in: self.models) == nil) {
				// add it
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












