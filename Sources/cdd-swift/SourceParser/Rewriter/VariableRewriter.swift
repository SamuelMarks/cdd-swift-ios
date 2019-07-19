//
//  VariableRewriter.swift
//  CYaml
//
//  Created by Rob Saunders on 7/12/19.
//

import Foundation

import SwiftSyntax

extension SourceFile {
	mutating func renameVariable(_ varName: String, _ varValue: String) -> Result<(), Swift.Error> {
		do {
			let rewriter = VariableValueRewriter()
			rewriter.varName = varName
			rewriter.varValue = varValue
			self.syntax = rewriter.visit(self.syntax) as! SourceFileSyntax
			return .success(())
		} catch let err {
			return .failure(err)
		}
	}

	mutating func renameClassVariable(className: String, variable: Variable) -> Result<(), Swift.Error> {
		do {
			let rewriter = ClassVariableRewriter()
			self.syntax = rewriter.visit(self.syntax) as! SourceFileSyntax
			return .success(())
		} catch let err {
			return .failure(err)
		}
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
