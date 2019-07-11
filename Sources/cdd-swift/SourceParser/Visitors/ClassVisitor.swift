////  RoutesVisitor
////  - finds and identifies models and model fields

import SwiftSyntax

struct Klass {
	let name: String
	var interfaces: [String] = []
	var vars: [String:MemberVarType] = [:]

	init(name: String) {
		self.name = name
	}
}

//struct MemberVar {
//	let type: MemberVarType
//}

enum MemberVarType {
	case String
	case Int
	case Date
	case Complex(String)
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
				switch varType {
				case "String?", "String":
					klass.vars[varName] = MemberVarType.String
//					fields[field.variableName] = ComponentField(type: "string", format: "string")
//				case "[String]":
//					fields[field.variableName] = ComponentField(type: "[string]", format: "[string]")
//				case "Int", "Int64", "UInt64":
//						fields[field.variableName] = ComponentField(type: "integer", format: "int64")
//				case "Int32", "UInt32":
//					fields[field.variableName] = ComponentField(type: "integer", format: "int32")
//				case "Float":
//					fields[field.variableName] = ComponentField(type: "number", format: "float")
//				case "Date":
//					fields[field.variableName] = ComponentField(type: "string", format: "date")
//				case "^[(.*)]s":
//					fields[field.variableName] = ComponentField(type: "string", format: "date")
				default:
					klass.vars[varName] = MemberVarType.Complex(varType)
				}

			}
			klasses.append(klass)
		}
		return .skipChildren
	}
}

