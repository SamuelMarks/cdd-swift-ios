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

	func compare(to oldModel:Model) -> [VariableChange] {
		var changes: [VariableChange] = []
		var oldVariables = oldModel.vars
		for variable in self.vars {

			if let index = oldVariables.firstIndex(where: {$0.name == variable.name}) {
                oldVariables.remove(at: index)
            }
            else {
                changes.append(.insertion(variable))
            }
		}

		changes.append(contentsOf:oldVariables.map {.deletion($0)})

		return changes
	}
}
