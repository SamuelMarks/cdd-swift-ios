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

	func compare(to oldRequest:Request) -> [RequestChange] {
		var changes: [RequestChange] = []
		var oldVariables = oldRequest.vars
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

		if urlPath != oldRequest.urlPath {
			changes.append(.path(urlPath))
		}
		if method != oldRequest.method {
			changes.append(.method(method))
		}
		if responseType != oldRequest.responseType {
			changes.append(.responseType(responseType))
		}
		if errorType != oldRequest.errorType {
			changes.append(.errorType(errorType))
		}

		return changes
	}
}

enum Method: String {
	case get
	case put
	case post
}

private extension Request {
	func response() -> OperationResponse? {
		if responseType == "EmptyResponse" {
			return nil
		}
		return OperationResponse(statusCode: 200, response: PossibleReference.reference(Reference("#/components/schemas" + responseType + "\"")))
	}

	func defaultResponse() -> PossibleReference<Response>? {
		if errorType == "EmptyResponse" {
			return nil
		}
		return PossibleReference.reference(Reference("$ref: \"#/components/schemas/" + errorType + "\""))
	}
}
