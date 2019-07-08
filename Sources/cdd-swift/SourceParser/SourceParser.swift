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

func parseRoute(syntax: SourceFileSyntax) -> [Route] {
	let visitor = RoutesVisitor()
	syntax.walk(visitor)

	return visitor.routes
}

struct ProjectInfo {
	var hostname: String
}

func findProjectInfo(syntax: SourceFileSyntax) -> ProjectInfo {
	let visitor = ExtractVariables()
	syntax.walk(visitor)

	print(visitor.variables)

	return ProjectInfo(hostname: "blah")
}

func ParseSource(_ files: [String], settingsFile: String) -> Project {
	var models: [Model] = []
	var routes: [Route] = []

	switch fileToSyntax(settingsFile) {
	case .success(let syntax):
		print(ParseVariables(syntax))
	case .failure(let err):
		print("error parsing settings file: \(err)")
	}

	for file in files {
		switch fileToSyntax(file) {
		case .success(let syntax):
			models.append(contentsOf: parseModel(syntax: syntax))
			routes.append(contentsOf: parseRoute(syntax: syntax))

//			print(ParseVariables(syntax))

//			findProjectInfo(syntax: syntax)
		case .failure(let err):
			print("error parsing file: \(err)")
		}
	}

	return Project(
		models: models,
		routes: routes)
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
