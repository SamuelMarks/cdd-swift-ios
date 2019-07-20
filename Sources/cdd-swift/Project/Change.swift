//
//  Changes.swift
//  CYaml
//
//  Created by Rob Saunders on 7/15/19.
//

import Foundation

enum ProjectChange {
    case model(Model, Change)
    case request(Request, Change)
}

enum Change {
    case insertion
    case deletion
    case update(changes: [VariableChange])
}

enum VariableChange {
	case deletion(Variable)
	case insertion(Variable)
}

extension Project {

    func compare(_ oldProject: Project) -> [ProjectChange] {
		let project = self
        var projectChanges: [ProjectChange] = []
		let models = project.models
		var oldModels = oldProject.models

		for model in models {
			if let index = oldModels.firstIndex(where: {$0.name == model.name}) {
				let oldModel = oldModels[index]
				let changes = model.compare(to: oldModel)
				if changes.count > 0 {
                    projectChanges.append(.model(model, .update(changes:changes)))
				}
				oldModels.remove(at: index)

			}
			else {
                projectChanges.append(.model(model, .insertion))
			}
		}
        
        projectChanges.append(contentsOf:oldModels.map { .model($0,.deletion) })

		let requests = project.requests
		var oldRequests = oldProject.requests
		for request in requests {
			if let index = oldRequests.firstIndex(where: {$0.name == request.name}) {
				let oldRequest = oldRequests[index]
				let changes = request.compare(to: oldRequest)
				if changes.count > 0 {
                    projectChanges.append(.request(request, .update(changes:changes)))
				}
				oldRequests.remove(at: index)
			}
			else {
                projectChanges.append(.request(request, .insertion))
			}
		}
        projectChanges.append(contentsOf:oldRequests.map { .request($0,.deletion) })
        
		return projectChanges
	}
}

