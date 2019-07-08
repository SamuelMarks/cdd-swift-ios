import SwiftSyntax

struct VariableDeclaration {
	let variableName, variableType: String
}

//func RecursiveFindVariables(syntax: SourceFileSyntax, variables: [VariableDeclaration]) -> SourceFileSyntax {
//	guard syntax.numberOfChildren != 0 else {
//		for node in syntax.children()  {
//			RecursiveFindVariables(node)
//		}
//	}
//}

func ParseVariables(_ syntax: SourceFileSyntax) -> [VariableDeclaration] {
	let visitor = ExtractVariables()
	syntax.walk(visitor)
	return visitor.variables
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
