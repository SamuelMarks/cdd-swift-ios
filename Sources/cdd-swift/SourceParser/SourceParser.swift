//
//  SourceParser.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation
import SwiftSyntax

func parseModels(syntaxes: [SourceFileSyntax]) -> [String: Model] {
	let visitor = ClassVisitor()
	var models: [String: Model] = [:]

	for syntax in syntaxes {
		syntax.walk(visitor)
	}

	for klass in visitor.klasses {
		models[klass.name] = Model(name: klass.name)
	}

	return models
}

func parseRoutes(syntaxes: [SourceFileSyntax]) -> [String: Route] {
	let visitor = RoutesVisitor()
	var routes: [String: Route] = [:]

	for syntax in syntaxes {
		syntax.walk(visitor)
	}

	// todo: complete
	return routes
}

func parseProjectInfo(syntax: SourceFileSyntax) -> ProjectInfo {
	let visitor = ExtractVariables()
	syntax.walk(visitor)

	let hostname =  URL(string: visitor.variables["HOST"]! + visitor.variables["ENDPOINT"]!)

	return ProjectInfo(hostname: hostname!)
}
