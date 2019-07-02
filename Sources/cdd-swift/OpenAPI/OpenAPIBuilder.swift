//
//  OpenAPIBuilder
//  - Creates OpenAPI objects from ASTs.

import Foundation
import SwiftSyntax

class OpenAPIBuilder {
	var data: OpenApi = OpenApi.init()

	func readModel(file: String) {
		// todo: pass back error as result
		let _ = fileToSyntax(file).map { syntax in
			parseModel(syntax: syntax)
		}
	}

	func readRoute(file: String) {
		// todo: pass back error as result
		let _ = fileToSyntax(file).map { syntax in
			parseRoutes(syntax: syntax)
		}
	}

	func parseModel(syntax: SourceFileSyntax) {
		let visitor = ModelsVisitor()
		syntax.walk(visitor)

		for (name, model) in visitor.models {
			self.data.components["schemas"]![name] = model
		}
	}

	func parseRoutes(syntax: SourceFileSyntax) {
		let visitor = RoutesVisitor()
		syntax.walk(visitor)

		for (path, route) in visitor.paths {
			self.data.paths[path] = route
		}
	}
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
