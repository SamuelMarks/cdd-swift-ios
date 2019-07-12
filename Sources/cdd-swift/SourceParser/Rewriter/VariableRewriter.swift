//
//  VariableRewriter.swift
//  CYaml
//
//  Created by Rob Saunders on 7/12/19.
//

import Foundation

import SwiftSyntax

extension SourceFile {
	mutating func renameVariable(varName: String, varValue: String) -> Result<(), Swift.Error> {
		do {
			let rewriter = VariableValueRewriter()
			rewriter.varName = "HOST"
			rewriter.varValue = "FUCKYOU:999"
			self.syntax = rewriter.visit(self.syntax) as! SourceFileSyntax
			return .success(())

		} catch let err {
			return .failure(err)
		}

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
