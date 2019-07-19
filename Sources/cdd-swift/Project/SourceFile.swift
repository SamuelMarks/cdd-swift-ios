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

	private init(path: URL, modificationDate: Date, syntax: SourceFileSyntax) {
		self.path = path
		self.modificationDate = modificationDate
		self.syntax = syntax
	}

	mutating func update(projectInfo: ProjectInfo) {
		let host = "\(projectInfo.hostname.scheme!)://\(projectInfo.hostname.host!)"
		let _ = self.renameVariable("HOST", host)
		let _ = self.renameVariable("ENDPOINT", projectInfo.hostname.path)
	}

	mutating func update(model: Model) {
		for variable in model.vars {
			switch self.renameClassVariable(className: model.name, variable: Variable(name: "blah")) {
			case .success(_):
				log.eventMessage("Updated variable: \(variable.name)")
			case .failure(_):
				log.errorMessage("Failed to update variable: \(variable.name)")
			}
		}
	}

	mutating func delete(model: Model) {
		log.errorMessage("UNIMPLEMENTED: delete(model)")
	}

	static func create(path: URL, model: Model) -> SourceFile {
		// todo: add fields
		return SourceFile(
			path: path,
			modificationDate: Date(),
			syntax: makeStruct(name: model.name))
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
