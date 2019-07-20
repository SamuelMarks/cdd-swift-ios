//
//  Request.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

struct Request {
	let name: String
	let method: Method
	let urlPath: String
	let responseType: String
	let errorType: String
	let vars: [Variable]

	func compare(to oldRequest:Request) -> [VariableChange] {
		var changes: [VariableChange] = []
		var oldVariables = oldRequest.vars
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

enum Method: String {
	case get
	case put
	case post
}
