//
//  SourceFile.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation
import SwiftSyntax

struct SourceFile: ProjectSource {
	let path: URL
	let modificationDate: Date
	var syntax: SourceFileSyntax

	init(path: String) throws {
		do {
			let url = URL(fileURLWithPath: path)
			self.path = url
			self.modificationDate = try fileLastModifiedDate(url: url)
			self.syntax = try SyntaxTreeParser.parse(url)
		}
	}

	private init(path: URL, modificationDate: Date, syntax: SourceFileSyntax) {
		self.path = path
		self.modificationDate = modificationDate
		self.syntax = syntax
	}

	mutating func update(projectInfo: ProjectInfo) {
		let host = "\(projectInfo.hostname.scheme!)://\(projectInfo.hostname.host!)"
		let _ = self.renameVariable("HOST", host)
		let _ = self.renameVariable("ENDPOINT", projectInfo.hostname.path)
	}

    mutating func remove(model: Model) {
        self.syntax = ClassRemover.remove(name: model.name, in: self.syntax)
    }
    
    mutating func insert(model: Model) {
        update(vars:model.vars,oldVars:[],inClass:model.name)
    }
    
    mutating func update(model: Model) {
        let result = parse(sourceFiles: [self])
        guard let oldModel = result.0.first(where: {$0.name == model.name}) else { return }
        update(vars: model.vars,oldVars: oldModel.vars, inClass: model.name)
    }
    
    mutating func update(vars: [Variable], oldVars: [Variable], inClass name:String) {
        let changes = vars.compare(to: oldVars)
        
        for change in changes {
            guard let classSyntax = findClass(name: name) else { return }
            
            switch change {
            case .deletion(let variable):
                let newClassSyntax = VariableRemover.remove(name: variable.name, in: classSyntax)
                self.syntax = ClassRewriter.rewrite(name: name, syntax: newClassSyntax, in: self.syntax)
            case .insertion(let variable):
                let rewriter = StructContentRewriter {
                    return $0.appending(variable.syntax())
                }
                let newClassSyntax = rewriter.visit(classSyntax)
                self.syntax = ClassRewriter.rewrite(name: name, syntax: newClassSyntax, in: self.syntax)
            case .same(let variable):
                let newClassSyntax = VariableRewriter.rewrite(name: variable.name, syntax: variable.syntax(), in: classSyntax)
                self.syntax = ClassRewriter.rewrite(name: name, syntax: newClassSyntax, in: self.syntax)
            }
        }
    }
    
    mutating func remove(request:Request) {
        self.syntax = ClassRemover.remove(name: request.name, in: self.syntax)
    }
    
    mutating func insert(request:Request) {
        update(vars:request.vars,oldVars:[],inClass:request.name)
    }
    
    mutating func update(request:Request) {
        let result = parse(sourceFiles: [self])
        guard let oldRequest = result.1.first(where: {$0.name == request.name}) else { return }
        update(vars: request.vars,oldVars: oldRequest.vars, inClass: request.name)
    }
    
    
    func findClass(name: String) -> StructDeclSyntax? {
        let visitor = ClassVisitor()
        syntax.walk(visitor)
        return visitor.syntaxes[name]
    }
    
	static func create(path: String, name: String) -> SourceFile? {
        guard let url = URL(string: path) else {
            return nil
        }
		// todo: add fields
		return SourceFile(
			path: url,
			modificationDate: Date(),
			syntax: makeStruct(name: name))
	}

	func containsClassWith(name: String) -> Bool {
		let visitor = ClassVisitor()
		self.syntax.walk(visitor)
        return visitor.klasses.contains(where: {$0.name == name})
	}
}

extension Request {
    func methodSyntax() -> Syntax {
        return SyntaxFactory.makeStringSegment("method: String { return .\(method) }")
    }
    
    func urlSyntax() -> Syntax {
        return SyntaxFactory.makeStringSegment("urlPath: String { return \"\(urlPath)\" }")
    }
    
    func responseTypeSyntax() -> Syntax {
        return SyntaxFactory.makeStringSegment("typealias ResponseType = " + responseType)
    }
    
    func errorTypeSyntax() -> Syntax {
        return SyntaxFactory.makeStringSegment("typealias ErrorType = \(errorType) ")
    }
}

extension Variable {
//    func syntax() -> Syntax {
//        return SyntaxFactory.makeStringSegment(swiftCode())
//    }
    
    func syntax() -> MemberDeclListItemSyntax {
        let type = self.type.swiftCode() + (optional ? "?" : "")
        let Pattern = SyntaxFactory.makePatternBinding(
            pattern: SyntaxFactory.makeIdentifierPattern(
                identifier: SyntaxFactory.makeIdentifier(name).withLeadingTrivia(.spaces(1))),
            typeAnnotation: SyntaxFactory.makeTypeAnnotation(
                colon: SyntaxFactory.makeColonToken().withTrailingTrivia(.spaces(1)),
                type: SyntaxFactory.makeTypeIdentifier(type)),
            initializer: nil, accessor: nil, trailingComma: nil)
        
        let decl = VariableDeclSyntax {
            $0.useLetOrVarKeyword(SyntaxFactory.makeLetKeyword().withLeadingTrivia([.carriageReturns(1), .tabs(1)]))
            $0.addPatternBinding(Pattern)
        }
        
        let listItem = SyntaxFactory.makeMemberDeclListItem(decl: decl, semicolon: nil)
        return listItem
    }
    
    func swiftCode() -> String {
        return name + ": " + type.swiftCode() + (optional ? "?" : "")
    }
}

extension Type {
    func swiftCode() -> String {
        switch self {
        case .primitive(let type):
            return type.rawValue
        case .array(let type):
            return "[\(type.swiftCode())]"
        case .complex(let type):
            return type
        }
    }
}
