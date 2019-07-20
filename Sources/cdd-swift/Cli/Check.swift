//
//  Check.swift
//  CYaml
//
//  Created by Rob Saunders on 7/19/19.
//

import Foundation
import SwiftCLI

class CheckCommand: Command {
	func execute() throws {
//		let source = try SourceFile.init(path: "/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Template/Source/API/Models/Pet.swift")

		var source = makeStruct(name: "Petty")
//		source.addFunction(functionName: "MyFunction")

		source.addVariable(variableName: "a", variableType: "Int")
		source.addVariable(variableName: "b", variableType: "String")
		print(source)
	}

	let name = "check"
	let shortDescription = "Check function"
}
