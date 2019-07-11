////  RoutesVisitor
////  - finds and identifies models and model fields

import SwiftSyntax

struct Klass {
	let name: String
	var interfaces: [String] = []
    var vars: [String:Field] = [:]

	init(name: String) {
		self.name = name
	}
}

class ClassVisitor : SyntaxVisitor {
	var klasses: [Klass] = []

	override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
		let klassName = "\(node.identifier)".trimmingCharacters(in: .whitespaces)
		var klass = Klass(name: klassName)

		for member in node.children {
			if type(of: member) == TypeInheritanceClauseSyntax.self {
				for child in member.children {
					if type(of: child) == InheritedTypeListSyntax.self {
						klass.interfaces.append(trim("\(child)"))
					}
				}
			}

			let extractFields = ExtractVariables()
			member.walk(extractFields)

			for (varName, varType) in extractFields.variables {
                let required = varType.suffix(1) != "?"
                let cleanType = varType.replacingOccurrences(of: "?", with: "")
                klass.vars[varName] = Field(name: varName, required: required, type: typeFor(type: cleanType))
			}
			klasses.append(klass)
		}
		return .skipChildren
	}
    
    func typeFor(type:String) -> Type {
        guard type.first != "["  else {
            let inType = String(type.dropFirst().dropLast())
            return Type.array(typeFor(type: inType))
        }
        switch type {
        case "String":
            return Type.primitive(.String)
        case "Int":
            return Type.primitive(.Int)
        case "Bool":
            return Type.primitive(.Bool)
        case "Float":
            return Type.primitive(.Float)
        default:
            return Type.complex(type)
        }
    }
}

