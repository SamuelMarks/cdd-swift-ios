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

	mutating func update(projectInfo: ProjectInfo) {
		let host = "\(projectInfo.hostname.scheme!)://\(projectInfo.hostname.host!)"
		let _ = self.renameVariable("HOST", host)
		let _ = self.renameVariable("ENDPOINT", projectInfo.hostname.path)
	}

	mutating func update(model: Model) {
		print("UNIMPLEMENTED: apply(model)")
	}

	mutating func delete(model: Model) {
		print("UNIMPLEMENTED: delete(model)")
	}

	mutating func insert(model: Model) {
		print("UNIMPLEMENTED: insert(model)")
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
