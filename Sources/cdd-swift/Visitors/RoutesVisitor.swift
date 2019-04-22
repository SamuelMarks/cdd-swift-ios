//
//  RoutesVisitor

import SwiftSyntax

class RoutesVisitor : SyntaxVisitor {
	var paths: [String : [String : Path]] = [:]

	// find classes,
	override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
//		let modelName: String = "\(node.identifier)"

		// for each class,
		for member in node.children {
			// look for class member variables
			let memberVars = MemberVariableExtractor()
			member.walk(memberVars)

			if let baseUrl = memberVars.memberVars["baseUrl"] {

				// look for class methods
				let fns = RouteExtractor()
				member.walk(fns)

				// found a baseUrl, try to find paths.
				var path:[String:Path] = [:]
				if let method = fns.method, let operationId = fns.operationId {
					path[method] = Path(operationId: operationId, parameters: [], responses: [])
				}

				paths[baseUrl] = path
			}
		}

		return .visitChildren
	}
}

//class ExtractRouteMethod : SyntaxVisitor {
////	var fields: [Field] = []`
//
//	override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
//		print("node id: \(node.identifier)")
//
//
//		for child in node.children{
//			print("child: \(type(of: child))")
//
//			switch type(of: child) {
//			case is FunctionSignatureSyntax.Type:
//				print("function sig: \(child.description)")
//			case is TokenSyntax.Type:
//				print("tokensyntax: \(child.description)")
//			default:
//				print("defualt")
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
//
////	override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
////
//////		let f: String? = node.children.first(where: { child in
//////			type(of: child) == IdentifierPatternSyntax.self
//////		}).map({child in
//////			"\(child)"
//////		})
//////
//////		let t = node.children.first(where: { child in
//////			type(of: child) == TypeAnnotationSyntax.self
//////		}).map({child in
//////			"\((child as! TypeAnnotationSyntax).type)"
//////		})
//////
//////		if let fieldName = f, let fieldType = t {
//////			fields.append(Field(fieldName: fieldName, fieldType: fieldType))
//////		}
////
////		return .skipChildren
////	}
//}
//	var baseUrl: String? = nil
//
//	override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
//		var key: String?
//		var value: String?
//
//		for child in node.children {
//			switch type(of: child) {
//			case is IdentifierPatternSyntax.Type:
//				key = "\(child)".trimmingCharacters(in: .whitespaces)
//			case is InitializerClauseSyntax.Type:
//				for child in child.children {
//					if type(of: child) == StringLiteralExprSyntax.self {
//						value = "\(child)".trimmingCharacters(in: .whitespaces)
//					}
//				}
//			default: ()
//			}
//
//		}
////		if let key = key, let value = value {
////			print("KEY VALUE! " + key + value)
////		}
////		print("KEY: ", key)
//		if key == Optional("baseUrl") {
//			if let baseUrl = value {
//				self.baseUrl = baseUrl
//			}
//		}
//
//		return .skipChildren
//	}

//	override func visit(_ node: ValueBindingPatternSyntax) -> SyntaxVisitorContinueKind {
//		for child in node.children {
//			print("child \(child)")
//		}
//		return .skipChildren
//	}

//	override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
//		for child in node.children {
//			print("child \(child)")
//		}
//		return .skipChildren
//	}

//	override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
//		for child in node.children {
//			print("child \(child)")
//		}
//		return .skipChildren
//	}

