import SwiftSyntax

class TokenVisitor : SyntaxVisitor {
    var api: OpenApi = OpenApi.init()

	/// called before visiting the node and its descendents.
    override func visitPre(_ node: Syntax) {
        var syntax = "\(type(of: node))"
        if syntax.hasSuffix("Syntax") {
            syntax = String(syntax.dropLast(6))
        }
    }

	/// Visiting `TokenSyntax` specifically.
	///   - Parameter node: the node we are visiting.
	///   - Returns: how should we continue visiting.
    override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
		switch token.tokenKind {
		case .structKeyword:
			if let parent = token.parent {
				if let structNameNode = parent.child(at: token.indexInParent + 1) {
					print("found new model: \(structNameNode)")
					let structName: String = structNameNode.description;

					let path = Path(route: Route(method: Method(type: structNameNode.description)))
					self.api.paths.append(path)

					self.api.components[structName] = Component(required: ["test"])

					// now iterate children (refactor)




//					print("new api: \(self.api)")
				}
			}
		case .letKeyword:
			if let parent = token.parent {
				if let varNameNode = parent.child(at: token.indexInParent + 1) {
					let fieldName: String = varNameNode.description;
					print("- field found: \(fieldName)")

				}
			}
		default: ()
		}

        return .visitChildren
    }

    override func visitPost(_ node: Syntax) {
    }
}
