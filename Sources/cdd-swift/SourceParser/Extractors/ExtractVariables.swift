import SwiftSyntax

struct VariableDeclaration {
	let variableName, variableType: String
}

class ExtractVariables : SyntaxVisitor {
	var variables: [VariableDeclaration] = []

	override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {

		let f: String? = node.children.first(where: { child in
			type(of: child) == IdentifierPatternSyntax.self
		}).map({child in
			"\(child)"
		})

		let t = node.children.first(where: { child in
			type(of: child) == TypeAnnotationSyntax.self
		}).map({child in
			"\((child as! TypeAnnotationSyntax).type)"
		})

		if let fieldName = f, let fieldType = t {
			variables.append(VariableDeclaration(variableName: fieldName, variableType: fieldType))
		}

		return .skipChildren
	}
}
