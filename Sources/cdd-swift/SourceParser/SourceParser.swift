//
//  SourceParser.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation
import SwiftSyntax

func parseModel(syntax: SourceFileSyntax) -> [Model] {
	let visitor = ModelsVisitor()
	syntax.walk(visitor)

	return visitor.models
}

func ParseSource(_ file: String) -> Project {
	let models: [Model]

	switch fileToSyntax(file) {
		case .success(let syntax):
			models = parseModel(syntax: syntax)
		case .failure:
			models = []
	}

	return Project(
		models: models,
		routes: [])
}

func fileToSyntax(_ file: String) -> Result<SourceFileSyntax, Swift.Error> {
	do {
		let syntax = try SyntaxTreeParser.parse(URL(fileURLWithPath: file))
		return .success(syntax)
	}
	catch let error {
		return .failure(error)
	}
}
