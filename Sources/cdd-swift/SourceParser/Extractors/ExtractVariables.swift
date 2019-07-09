import SwiftSyntax

struct VariableDeclaration {
	let variableName, variableType: String
}

func ParseVariables(_ syntax: SourceFileSyntax) -> Dictionary<String, String> {
	let visitor = ExtractVariables()
	syntax.walk(visitor)
	return visitor.variables
}

class ExtractVariables : SyntaxVisitor {
	var variables: Dictionary<String, String> = [:]

	override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
		var varName : String?

		for child in node.children {
			if type(of: child) == IdentifierPatternSyntax.self {
				varName = "\(child)".trimmingCharacters(in: .whitespacesAndNewlines)
			}
			for subchild in child.children {
				if type(of: subchild) == StringLiteralExprSyntax.self {
					if varName != nil {
						variables[varName!] = "\(subchild)".replacingOccurrences(of: "\"", with: "")
					}
				}
			}
		}

		return .skipChildren
	}
}
