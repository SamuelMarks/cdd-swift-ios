//
//  SourceFile.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation
import SwiftSyntax

struct SourceFile {
	let path: URL
	let modificationDate: Date
	var syntax: SourceFileSyntax

	init(path: String) throws {
		do {
			let url = URL(fileURLWithPath: path)
			self.path = url
			self.modificationDate = try fileLastModifiedDate(url: url)
			self.syntax = try SyntaxTreeParser.parse(url)
		}
	}

	mutating func apply(projectInfo: ProjectInfo) {
		let host = "\(projectInfo.hostname.scheme!)://\(projectInfo.hostname.host!)"
		let _ = self.renameVariable("HOST", host)
		let _ = self.renameVariable("ENDPOINT", projectInfo.hostname.path)
	}

	mutating func apply(model: Model) {
		print("todo: update model in source file")
	}

	mutating func delete(model: Model) {
		print("todo: delete model in source file")
	}

	func contains(model name: String) -> Bool {
		let visitor = ClassVisitor()
		self.syntax.walk(visitor)

		for klass in visitor.klasses {
			if klass.interfaces.contains(MODEL_PROTOCOL) && klass.name == name {
				return true
			}
		}

		return false
	}
}
