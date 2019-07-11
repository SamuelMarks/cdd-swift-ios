//
//  Generate.swift
//  Basic
//
//  Created by Rob Saunders on 7/8/19.
//

import Foundation
import SwiftCLI

class GenerateCommand: Command {
	func execute() throws {
		let syntax = fileToSyntax("/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Test.swift")

		do {
			let result = try syntax.result.get()

			for (_, model) in parseModels(syntaxes: [result]) {
				print(model)
			}

			for (_, route) in parseRoutes(syntaxes: [result]) {
				print(route)
			}
		} catch (let err) {
			print("error \(err)")
		}
	}

	let name = "generate"
	let shortDescription = "Generates a new swift CDD-Swift project"
}
