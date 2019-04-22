import SwiftSyntax

class ModelsVisitor : SyntaxVisitor {
	var models: [String : SchemaComponent] = [:]

	override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
		let modelName = "\(node.identifier)".trimmingCharacters(in: .whitespaces)
		print("found model: \(modelName)")

		for member in node.children {
			let extractFields = ExtractVariables()
			member.walk(extractFields)

			var fields:Dictionary<String, ComponentField> = [:]
			for field in extractFields.variables {
				switch(field.variableType) {
					case "String?":
						fields[field.variableName] = ComponentField(type: "string", format: "string")
					case "[String]":
						fields[field.variableName] = ComponentField(type: "[string]", format: "[string]")
					case "String":
						fields[field.variableName] = ComponentField(type: "string", format: "string")
					case "Int":
						fields[field.variableName] = ComponentField(type: "integer", format: "int64")
					default:
						print("unknown field: \(field)")
				}

			}

			self.models["\(modelName)"] = SchemaComponent(type: "blah", properties: fields)
		}
		return .skipChildren
	}
}
