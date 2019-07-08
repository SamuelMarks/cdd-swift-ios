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
		print("hello")
	}

	let name = "generate"
	let shortDescription = "Generates code ..."
}
