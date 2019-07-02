//
//  ApiBaseVisitor

import SwiftSyntax

class ApiBaseVisitor : SyntaxVisitor {
	public var baseUrl: String?

	override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
		return .skipChildren
		
	}
}
