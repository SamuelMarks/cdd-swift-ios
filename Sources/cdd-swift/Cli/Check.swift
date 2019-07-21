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
		var source = try SourceFile.init(path: "/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Template/Source/API/Models/Pet.swift")

		source.syntax.addVariable("aaa", "Int")
		source.syntax.addVariable("bbb", "String")
		print(source.syntax)
	}

	let name = "check"
	let shortDescription = "Check function"
}
