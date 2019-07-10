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
		do {
			try WriteToYmlTest().run()
		} catch (let err) {
			print("error: \(err)")
		}

	}

	let name = "generate"
	let shortDescription = "Generates a new swift CDD-Swift project"
}
