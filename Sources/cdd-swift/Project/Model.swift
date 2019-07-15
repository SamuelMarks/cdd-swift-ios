//
//  Model.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation

struct Model {
	var name: String
	var vars: [Variable]
	var modificationDate: Date

	static func newest(_ left: Model, _ right: Model) -> Model {
		return left.modificationDate.compare(right.modificationDate) == .orderedAscending ? left : right
	}

	func merge(with olderModel: Model) -> Model {
		for variable in self.vars {
			//			let (newModel, oldModel) = Model.order(model, )
			if case let .some(variable) = variable.find(in: olderModel.vars) {
				print("found var: \(variable)")
				// model exists, merge it with the existing one
//				models.append(model.merge(with: otherModel))
			}
		}
		return Model(name: self.name, vars: [], modificationDate: self.modificationDate)
	}

	func find(in models: [Model]) -> Model? {
		return models.first(where: {
			self.name == $0.name
		})
	}

	func compare(to oldModel:Model) -> [ModelChange] {
		var changes: [ModelChange] = []
		var oldVariables = oldModel.vars
		for variable in self.vars {

			if let index = oldVariables.firstIndex(where: {$0.name == variable.name}) {
				let updates = variable.compare(to: oldVariables[index])
				oldVariables.remove(at: index)
				if updates.count > 0 {
					changes.append(.update(variable.name, updates))
				}
			}
			else {
				changes.append(.insertion(variable))
			}
		}

		changes.append(contentsOf:oldVariables.map {.deletion($0)})

		return changes
	}
}
