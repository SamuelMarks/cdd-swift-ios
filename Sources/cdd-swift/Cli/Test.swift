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
        
        try YmlToSwift().run(urlToSpec: YmlToSwift.testUrl, urlForSwiftFile: YmlToSwift.testUrlForSwift)
	}

	let name = "test"
	let shortDescription = "Test function"
}
