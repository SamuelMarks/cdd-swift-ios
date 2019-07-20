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
	public override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
		let rewriter = StringLiteralRewriter()
		log.errorMessage("UNFINISHED: ClassVariableRewriter()")
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
