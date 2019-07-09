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

//func ParseSource(_ files: [String], settingsFile: String) -> Result<Project, Swift.Error> {
//
//	var models: [Model] = []
//	var routes: [Route] = []
//
//	let res = fileToSyntax(settingsFile).map({ syntax in
//		return ParseVariables(syntax)
//	})
//
//	guard case .success = res else { return res.map({ _ in return Project(models: [], routes: [])}) }
//
//
//	switch fileToSyntax(settingsFile) {
//	case .success(let syntax):
//		print(ParseVariables(syntax))
//	case .failure(let err):
//		print("error parsing settings file: \(err)")
//	}
//
//	for file in files {
//		switch fileToSyntax(file) {
//		case .success(let syntax):
//			models.append(contentsOf: parseModel(syntax: syntax))
//			routes.append(contentsOf: parseRoute(syntax: syntax))
//
////			print(ParseVariables(syntax))
//
////			findProjectInfo(syntax: syntax)
//		case .failure(let err):
//			print("error parsing file: \(err)")
//		}
//	}
//
//	return Result.success(Project(
//		models: models,
//		routes: routes))
//}

func fileToSyntax(_ file: String) -> FileResult<SourceFileSyntax> {
	do {
		let syntax = try SyntaxTreeParser.parse(URL(fileURLWithPath: file))
		return FileResult(fileName: file, result: .success(syntax))
	}
	catch let error {
		return FileResult(fileName: file, result: .failure(error))
	}
}
