import SwiftSyntax

struct Field {
	let fieldName, fieldType: String
}

class ExtractField : SyntaxVisitor {
	var fields: [Field] = []


	override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {

		let f: String? = node.children.first(where: { child in
			type(of: child) == IdentifierPatternSyntax.self
		}).map({child in
			"\(child)"
		})

		let t = node.children.first(where: { child in
			type(of: child) == TypeAnnotationSyntax.self
		}).map({child in
			"\((child as! TypeAnnotationSyntax).type)"
		})

		if let fieldName = f, let fieldType = t {
			fields.append(Field(fieldName: fieldName, fieldType: fieldType))
		}
		
		return .skipChildren
	}

//	override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
//		print("VariableDeclSyntax block child found. ---\(node) \(type(of: node))---")
//
//		for child in node.children {
//			print("child block child found. ---\(child) \(type(of: child))---")
//		}
//
//		return .skipChildren
//	}

//	override func visit(_ node: MemberDeclListItemSyntax) -> SyntaxVisitorContinueKind {
//		print("MemberDeclListItemSyntax block child found. ---\(node) \(type(of: node))---")
//
//		for child in node.children {
//			print("child block child found. ---\(child) \(type(of: child))---")
//		}
//
//		return .skipChildren
//	}

//	override func visit(_ node: MemberDeclBlockSyntax) -> SyntaxVisitorContinueKind {
//
//		for child in node.children {
////			print("member block child found. ---\(child) \(type(of: child))---")
//		}
//		return .skipChildren
//	}


//	override func visit(_ node: TypeAnnotationSyntax) -> SyntaxVisitorContinueKind {
//		self.fieldType = "\(node.type)"
//		return .visitChildren
//	}
//
//	override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
//		self.fieldName = "\(node)"
//		return .visitChildren
//	}
}

class TokenVisitor : SyntaxVisitor {
    var api: OpenApi = OpenApi.init()

	override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {

		let modelName = node.identifier

		print("STRUCT: \(modelName)")
//		print("members: \(node.members)")

		for member in node.children {
//			print("member: \(member) - \(type(of: member))")
			let extractField = ExtractField()
			member.walk(extractField)

			print(extractField.fields)
//			print("FIELD: \(extractField.fieldName), type: \(extractField.fieldType)")
		}
//		let members = node.members.children;
//		members.walk(extractField)

//
//		print("children:")
//		for child in node.children {
//			print(" -- \(type(of: child)) > \(child)")
//		}

//		for child in node.children {
////			let nodeType = "\(type(of: child))"
////			print(" -- \(type(of: child)) \(TokenKind.init(from: node.))")
////			print(" -- \(child.identifier)")
//
////			TokenKind.init
//
////			let token = child as! TokenKind
////			print(child)
//
//			let extractField = ExtractField()
//			child.walk(extractField)
//
//
////			print("---- \(type(of: child)) :: \(child)")
//
////			if type(of: child) == TokenSyntax.self {
////				print(" - name: \(child)")
////			}
//
//		}

		return .skipChildren
	}

	override func visitPost(_ node: Syntax) {
		print("\n")
	}

	/// Visiting `TokenSyntax` specifically.
	///   - Parameter node: the node we are visiting.
	///   - Returns: how should we continue visiting.
    override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
//		print("-\(token.tokenKind)")
//		switch token.tokenKind {
//			case .structKeyword:




//
//
        // print("-\(token.tokenKind)")
//		switch token.tokenKind {
//		case .structKeyword:
//
////			print(token.)
//
//
//			if let parent = token.parent {
//				if let structNameNode = parent.child(at: token.indexInParent + 1) {
//					print("found new model: \(structNameNode)")
//					let structName: String = structNameNode.description;
//
//					let path = Path(route: Route(method: Method(type: structNameNode.description)))
//					self.api.paths.append(path)
//
//					self.api.components[structName] = Component(required: ["test"])
//
//					// now iterate children (refactor)
//
//
//
//
////					print("new api: \(self.api)")
//				}
//			}
//		case .letKeyword:
//			if let parent = token.parent {
//				if let varNameNode = parent.child(at: token.indexInParent + 1) {
//					let fieldName: String = varNameNode.description;
//					print("- field found: \(fieldName)")
//
//				}
//			}
//		default: ()
//		}

        return .visitChildren
    }

}
