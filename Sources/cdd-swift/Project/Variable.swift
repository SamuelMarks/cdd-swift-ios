//
//  Variable.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation

struct Variable {
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

	func compare(to oldVariable:Variable) -> [VariableChange] {
		var changes: [VariableChange] = []
		if optional != oldVariable.optional {
			changes.append(.optional(optional))
		}
		if type != oldVariable.type {
			changes.append(.type(type))
		}
		if value != oldVariable.value {
			changes.append(.value(value))
		}
		return changes
	}
}
