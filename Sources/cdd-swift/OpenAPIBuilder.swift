//
//  OpenAPIBuilder

import Foundation
import SwiftSyntax

class OpenAPIBuilder {
	var data: OpenApi = OpenApi.init()

	init() {
		let projectPath = "/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Examples/Basic/"

		let _ = fileToSyntax("\(projectPath)/Sources/api/Pets/Models.swift").map { syntax in
			parseModels(syntax: syntax)
		}

		let _ = fileToSyntax("\(projectPath)/Sources/api/Pets/Routes.swift").map { syntax in
			parseRoutes(syntax: syntax)
		}

		let _ = fileToSyntax("\(projectPath)/Sources/api/Pets/AuthApi.swift").map { syntax in
			parseRoutes(syntax: syntax)
		}
	}

	func parseAPIBase(syntax: SourceFileSyntax) {
//		let visitor = ApiBaseVisitor()
//		syntax.walk(visitor)
//
//		self.data.components = visitor.components
	}

	func parseModels(syntax: SourceFileSyntax) {
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


//		self.data.paths = visitor.paths
	}
}

func fileToSyntax(_ file: String) -> Result<SourceFileSyntax, Swift.Error> {
	return Result {
		try SyntaxTreeParser.parse(URL(fileURLWithPath: file))
	}
}
