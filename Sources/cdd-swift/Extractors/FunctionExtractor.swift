//
//  FunctionExtractor.swift
//  Basic
//
//  Created by Rob Saunders on 20/04/2019.
//

import SwiftSyntax

struct FunctionExtract {
	var functionName: String?
}

class FunctionExtractor : SyntaxVisitor {
	var method: String? = nil
	var operationId: String? = nil

	override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
		self.operationId = "\(node.identifier)"
		return .visitChildren
	}

	override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
		if "\(node.description)".contains("JsonHttpClient") {
			method = "\(node.name)"
		}

		return .skipChildren
	}



//	override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
//		print("token: \(token.text) - \(token.tokenKind) - \()")
//
////		if token.text == "JsonHttpClient" {
//////			print(token.numberOfChildren)
////			for child in token.parent.children ?? <#default value#> {
////				print("--\(token)--")
////			}
////		}
//
//		return .visitChildren
//	}

//	override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
//		print("fn name: \(node.identifier)")
//
//
//		for child in node.children{
////			print("child: \(type(of: child))")
//
//			switch type(of: child) {
//			case is FunctionSignatureSyntax.Type:
//				print("FunctionSignatureSyntax:")
//				for child in child.children {
//					print("--\(type(of: child)) - \(child.description)")
//				}
////			case is TokenSyntax.Type:
////				print("TokenSyntax: \(child.description)")
//			case is CodeBlockSyntax.Type:
//				print("TokenSyntax: \(child.description)")
//				for child in child.children {
//					print("--\(type(of: child)) - \(child.description)")
//				}
//			default:
//				print("default: \(type(of: child)) - \(child.description)")
//			}
//		}
//
//		let f: String? = node.children.first(where: { child in
//			type(of: child) == MemberDeclListSyntax.self
//		}).map({child in
//			"\(child)"
//		})
//
//		print("found: \(f)")
//
//		return .skipChildren
//	}

}
