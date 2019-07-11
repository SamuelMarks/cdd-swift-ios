import SwiftSyntax

struct VariableDeclaration {
	let variableName, variableType: String
}

func ParseVariables(_ syntax: SourceFileSyntax) -> Dictionary<String, String> {
	let visitor = ExtractVariables()
	syntax.walk(visitor)
	return visitor.variables
}

class ExtractReturnValue : SyntaxVisitor {
	var returnValue: String = ""

	override func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
		self.returnValue = trim("\(node)")
		return .skipChildren
	}
}

class ExtractVariables : SyntaxVisitor {
	var variables: Dictionary<String, String> = [:]

	override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
		var varName: String = ""

		for child in node.children {
			if type(of: child) == IdentifierPatternSyntax.self {
				varName = "\(child)"
			}

			if type(of: child) == InitializerClauseSyntax.self {
				if varName != "" {
					for c in child.children {
						if type(of: c) == StringLiteralExprSyntax.self {
							self.variables[varName] = "\(c)"
						}
					}
				}
			}

			if type(of: child) == CodeBlockSyntax.self {
				let returnWalker = ExtractReturnValue()
				child.walk(returnWalker)
				self.variables["\(varName)"] = "\(returnWalker.returnValue)"
			}
		}

		return .skipChildren
	}
}
