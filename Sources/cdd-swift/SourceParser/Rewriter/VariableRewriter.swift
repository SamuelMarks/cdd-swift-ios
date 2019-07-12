//
//  VariableRewriter.swift
//  CYaml
//
//  Created by Rob Saunders on 7/12/19.
//

import Foundation

import SwiftSyntax

public class VariableValueRewriter: SyntaxRewriter {
	var varName: String? = nil, varValue: String? = nil

	public override func visit(_ token: TokenSyntax) -> Syntax {
//		print("--\(token) \(token.tokenKind)")
//		guard case let .identifier(varName) = token.tokenKind {
//			print("found car name: \(varName)")
//		}

		switch token.tokenKind {
		case .identifier(let varName):
//			print("found varName name: \(varName)")
			()
		case .stringLiteral(let stringLiteral):
//			print("found stringLiteral name: \(stringLiteral)")
			()
		default:
			()
		}

//		guard case let  (text) = token.tokenKind else {
//			return token
//		}
//
//		return token.withKind(.stringLiteral(zalgo(text)))
		return token
	}
}
