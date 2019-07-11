//
//  SourceParser.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation
import SwiftSyntax

let MODEL_PROTOCOL = "APIModel"

func parseModels(syntaxes: [SourceFileSyntax]) -> [String: Model] {
	let visitor = ClassVisitor()
	var models: [String: Model] = [:]

	for syntax in syntaxes {
		syntax.walk(visitor)
	}

	for klass in visitor.klasses {
		if klass.interfaces.contains(MODEL_PROTOCOL) {
			models[klass.name] = Model(name: klass.name, fields: Array(klass.vars.values))
		}
	}

	return models
}

let ROUTE_PROTOCOL = "APIRequest"

func parseRoutes(syntaxes: [SourceFileSyntax]) -> [String: Route] {
	let visitor = ClassVisitor()
	var routes: [String: Route] = [:]

	for syntax in syntaxes {
		syntax.walk(visitor)
	}

	for klass in visitor.klasses {
		if klass.interfaces.contains(ROUTE_PROTOCOL) {
			if let e = klass.vars["urlPath"]?.type,
				case let .complex(url) = e {
				let paths = Route(paths: [RoutePath(urlPath: url, requests: [])])
				routes[klass.name] = paths
			}
		}
	}

	// todo: complete
	return routes
}

func parseProjectInfo(syntax: SourceFileSyntax) -> Result<ProjectInfo, Swift.Error> {
	let visitor = ExtractVariables()
	syntax.walk(visitor)

	guard let hostname = visitor.variables["HOST"], let endpoint = visitor.variables["ENDPOINT"] else {
		return .failure(
			ProjectError.InvalidSettingsFile("Cannot find HOST or ENDPOINT variables in Settings.swift"))
	}

	guard let hosturl = URL(string: hostname + endpoint) else {
		return .failure(
			ProjectError.InvalidHostname("Invalid hostname format: \(hostname), \(endpoint)"))
	}

	return .success(ProjectInfo(hostname: hosturl))
}
