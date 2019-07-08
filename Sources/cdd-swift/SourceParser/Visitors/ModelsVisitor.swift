////  RoutesVisitor
////  - finds and identifies models and model fields

import SwiftSyntax

class ModelsVisitor : SyntaxVisitor {
	var models: [Model] = []

	override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
		let modelName = "\(node.identifier)".trimmingCharacters(in: .whitespaces)
		print("found model: \(modelName)")

		for member in node.children {
			let extractFields = ExtractVariables()
			member.walk(extractFields)

//			var fields:Dictionary<String, ComponentField> = [:]

//			for field in extractFields.variables {
//				switch(field.variableType) {
//				case "String?", "String":
//					models.append(Model())
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
//				default:
//					print("unknown field: \(field)")
//				}
//
//			}
//            let pathExtractor = PathExtractor()
//            member.walk(extractSomething)
			models.append(Model(name: modelName))

//				)["\(modelName)"] = SchemaComponent(type: "blah", properties: fields)
		}
		return .skipChildren
	}
}

