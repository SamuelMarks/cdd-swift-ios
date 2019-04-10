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
}

class TokenVisitor : SyntaxVisitor {
    var api: OpenApi = OpenApi.init()

	override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
		let modelName = node.identifier

		for member in node.children {
			let extractField = ExtractField()
			member.walk(extractField)

//			for field in extractField.fields {
//
//			}
//			let component = ComponentObject(type: "object", properties: [:])
//			let properties = [:]

			var fields:Dictionary<String, ComponentField> = [:]
			for field in extractField.fields {
				switch(field.fieldType) {
					case "String?":
						fields[field.fieldName] = ComponentField(type: "string", format: "string")
					case "[String]":
						fields[field.fieldName] = ComponentField(type: "[string]", format: "[string]")
					case "String":
						fields[field.fieldName] = ComponentField(type: "string", format: "string")
					case "Int":
						fields[field.fieldName] = ComponentField(type: "integer", format: "int64")
					default:
						print("unknown field: \(field)")
				}

			}

			api.components.schemas["\(modelName)"] = ComponentObject(type: "object", properties: fields)
		}
		return .skipChildren
	}

	override func visitPost(_ node: Syntax) {
		print("\n")
	}

}
