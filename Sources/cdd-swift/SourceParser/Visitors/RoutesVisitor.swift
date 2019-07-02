//  RoutesVisitor
//  - finds and identifies route information in route objects

import SwiftSyntax

class RoutesVisitor : SyntaxVisitor {
	var paths: [String : [String : Path]] = [:]

	// find classes,
	override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {

		// for each class,
		for member in node.children {
			// look for class member variables
			let memberVars = MemberVariableExtractor()
			member.walk(memberVars)

			if let baseUrl = memberVars.memberVars["baseUrl"] {

				// look for class methods
				let fns = RouteExtractor()
				member.walk(fns)

				// found a baseUrl, try to find paths.
				var path:[String:Path] = [:]
				if let method = fns.method, let operationId = fns.operationId {
					path[method] = Path(operationId: operationId, parameters: [], responses: [])
				}

				paths[baseUrl] = path
			}
		}

		return .visitChildren
	}
}
