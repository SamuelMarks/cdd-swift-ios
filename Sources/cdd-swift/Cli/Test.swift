//
//  File.swift
//  CYaml
//
//  Created by Rob Saunders on 7/10/19.
//

import Foundation
import SwiftCLI

class TestCommand: Command {
	func execute() throws {
//		let syntax = fileToSyntax("Template/ios/API/API.swift")
		let syntax = fileToSyntax("Test.swift")
		let result = try! syntax.result.get()

		for (modelName, model) in parseModels(syntaxes: [result]) {
			print(model)
		}

		for (routeName, route) in parseRoutes(syntaxes: [result]) {
			print(route)
		}
	}

	let name = "test"
	let shortDescription = "Test function"
}
