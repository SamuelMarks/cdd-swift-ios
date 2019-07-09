//
//  SourceParser.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation
import SwiftSyntax

func parseModels(syntaxes: [SourceFileSyntax]) -> [Model] {
	let visitor = ModelsVisitor()

	for syntax in syntaxes {
		syntax.walk(visitor)
	}

	return visitor.models
}

func parseRoutes(syntaxes: [SourceFileSyntax]) -> [Route] {
	let visitor = RoutesVisitor()

	for syntax in syntaxes {
		syntax.walk(visitor)
	}

	return visitor.routes
}

func parseProjectInfo(syntax: SourceFileSyntax) -> ProjectInfo {
	let visitor = ExtractVariables()
	syntax.walk(visitor)

	print(visitor.variables)

	return ProjectInfo(hostname: "blah")
}
