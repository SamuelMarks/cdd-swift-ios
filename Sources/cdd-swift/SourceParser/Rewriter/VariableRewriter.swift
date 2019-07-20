//
//  VariableRewriter.swift
//  CYaml
//
//  Created by Rob Saunders on 7/12/19.
//

import Foundation
import SwiftSyntax

extension SourceFileSyntax {
	mutating func renameVariable(_ varName: String, _ varValue: String) {
		let rewriter = VariableValueRewriter()
		rewriter.varName = varName
		rewriter.varValue = varValue
		self = rewriter.visit(self) as! SourceFileSyntax
	}

	mutating func addVariable(_ varName: String, _ varValue: String) {
		let rewriter = AddClassVariableRewriter()
		rewriter.varName = varName
		rewriter.varValue = varValue
		if let syntax = rewriter.visit(self) as? SourceFileSyntax {
			self = syntax
		} else {
			log.errorMessage("could not add variable \(varName)")
		}
	}
}

extension SourceFile {
	mutating func renameVariable(_ varName: String, _ varValue: String) -> Result<(), Swift.Error> {
		let rewriter = VariableValueRewriter()
		rewriter.varName = varName
		rewriter.varValue = varValue
		guard let syntax = rewriter.visit(self.syntax) as? SourceFileSyntax else {
			return .failure(ProjectError.SourceFileParser("error converting source syntax"))
		}
		self.syntax = syntax
		return .success(())
	}

	mutating func renameClassVariable(className: String, variable: Variable) -> Result<(), Swift.Error> {
		let rewriter = ClassVariableRewriter()
		guard let syntax = rewriter.visit(self.syntax) as? SourceFileSyntax else {
			return .failure(ProjectError.SourceFileParser("error converting source syntax"))
		}
		self.syntax = syntax
		return .success(())
	}
}

public class AddClassVariableRewriter: SyntaxRewriter {
	var varName: String? = nil
	var varValue: String? = nil

	public override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
		let rewriter = StringLiteralRewriter()
		log.errorMessage("UNFINISHED: ClassVariableRewriter()")

//		let code = variableCodeBlock(variableName: "hi", variableType: "Int")
		let variableName = "hi"
		let variableType = "Int"

		let Pattern = SyntaxFactory.makePatternBinding(
			pattern: SyntaxFactory.makeIdentifierPattern(
				identifier: SyntaxFactory.makeIdentifier(variableName).withLeadingTrivia(.spaces(1))),
			typeAnnotation: SyntaxFactory.makeTypeAnnotation(
				colon: SyntaxFactory.makeColonToken().withTrailingTrivia(.spaces(1)),
				type: SyntaxFactory.makeTypeIdentifier(variableType)),
			initializer: nil, accessor: nil, trailingComma: nil)
		let decl = VariableDeclSyntax {
			$0.useLetOrVarKeyword(SyntaxFactory.makeLetKeyword())
			$0.addPatternBinding(Pattern)
		}

		let d = MemberDeclListItemSyntax {
			$0.useDecl(decl)
		}

		let b = node.members.addMemberDeclListItem(d)
		let block = MemberDeclBlockSyntax {
			$0.useLeftBrace(
				SyntaxFactory.makeLeftBraceToken(leadingTrivia: .spaces(1), trailingTrivia: .zero))
			$0.useRightBrace(
				SyntaxFactory.makeRightBraceToken(leadingTrivia: .newlines(1), trailingTrivia: .zero))
		}



//		node.members = node.members.addMemberDeclListItem(d)

//		node.withMembers(block)
//		node.withMembers(block)

		return rewriter.visit(node)
	}
}

public class ClassVariableRewriter: SyntaxRewriter {
	public override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
		let rewriter = StringLiteralRewriter()
		log.errorMessage("UNFINISHED: ClassVariableRewriter()")
		return rewriter.visit(node)
	}
}

public class VariableValueRewriter: SyntaxRewriter {
	var varName: String? = nil
	var varValue: String? = nil
	var node: Syntax?

	public override func visit(_ node: PatternBindingSyntax) -> Syntax {
		let rewriter = StringLiteralRewriter()

		for child in node.children {
			if type(of: child) == IdentifierPatternSyntax.self {
				if trim("\(child)") == self.varName {
					rewriter.varValue = self.varValue
				}
			}
		}

		return rewriter.visit(node)
	}
}

public class StringLiteralRewriter: SyntaxRewriter {
	var varValue: String? = nil

	public override func visit(_ token: TokenSyntax) -> Syntax {
		switch token.tokenKind {
		case .stringLiteral(_):
			if case let .some(vv) = varValue {
				return token.withKind(.stringLiteral(vv))
			}
		default:
			()
		}

		return token
	}
}
