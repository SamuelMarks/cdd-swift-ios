//
//  AddClassVariableRewriter.swift
//  CYaml
//
//  Created by Rob Saunders on 7/19/19.
//

import Foundation
import SwiftSyntax

func variableDecl(variableName: String, variableType: String) -> MemberDeclListItemSyntax {
	let Pattern = SyntaxFactory.makePatternBinding(
		pattern: SyntaxFactory.makeIdentifierPattern(
			identifier: SyntaxFactory.makeIdentifier(variableName).withLeadingTrivia(.spaces(1))),
		typeAnnotation: SyntaxFactory.makeTypeAnnotation(
			colon: SyntaxFactory.makeColonToken().withTrailingTrivia(.spaces(1)),
			type: SyntaxFactory.makeTypeIdentifier(variableType)),
		initializer: nil, accessor: nil, trailingComma: nil)

	let decl = VariableDeclSyntax {
		$0.useLetOrVarKeyword(SyntaxFactory.makeLetKeyword().withLeadingTrivia([.carriageReturns(1), .tabs(1)]))
		$0.addPatternBinding(Pattern)
	}

	let listItem = SyntaxFactory.makeMemberDeclListItem(decl: decl, semicolon: nil)
	return listItem
}

func variableCodeBlock(variableName: String, variableType: String) -> CodeBlockItemSyntax {
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
	return CodeBlockItemSyntax {$0.useItem(decl)}
}

func functionCodeBlock(functionName: String, functionParam: String) -> CodeBlockItemSyntax {
	let string = SyntaxFactory.makeStringLiteralExpr(functionName)
	let printID = SyntaxFactory.makeVariableExpr(functionParam)
	let arg = FunctionCallArgumentSyntax {
		$0.useExpression(string)
	}
	let call = FunctionCallExprSyntax {
		$0.useCalledExpression(printID)
		$0.useLeftParen(SyntaxFactory.makeLeftParenToken())
		$0.addFunctionCallArgument(arg)
		$0.useRightParen(SyntaxFactory.makeRightParenToken())
	}
	return CodeBlockItemSyntax {
		$0.useItem(call)
	}
}
