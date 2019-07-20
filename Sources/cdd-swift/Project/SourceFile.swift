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
        log.errorMessage("UNIMPLEMENTED: delete(model)")
    }
    
    mutating func insert(model: Model) {
        log.errorMessage("UNIMPLEMENTED: insert(model)")
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
                log.errorMessage("UNIMPLEMENTED: remove (Variable) \(variable)")
            case .insertion(let variable):
                log.errorMessage("UNIMPLEMENTED: insert (Variable) \(variable)")
            case .same(let variable):
                let newModelSyntax = VariableRewriter.rewrite(name: variable.name, syntax: variable.syntax(), in: classSyntax)
                self.syntax = ClassRewriter.rewrite(name: name, syntax: newModelSyntax, in: self.syntax)
            }
        }
    }
    
    mutating func remove(request:Request) {
        log.errorMessage("UNIMPLEMENTED: remove(request)")
    }
    
    mutating func insert(request:Request) {
        log.errorMessage("UNIMPLEMENTED: insert(request)")
    }
    
    mutating func update(request:Request) {
//        print(syntax)
        let result = parse(sourceFiles: [self])
        guard let oldRequest = result.1.first(where: {$0.name == request.name}) else { return }
        update(vars: request.vars,oldVars: oldRequest.vars, inClass: request.name)
        
        /// need finish for response url method error
//        let responseSyntax = request.responseTypeSyntax()
//        let newModelSyntax = VariableRewriter.rewrite(name: variable.name, syntax: variable.syntax(), in: classSyntax)
//        self.syntax = ClassRewriter.rewrite(name: name, syntax: newModelSyntax, in: self.syntax)
        
//        print(syntax)
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
    func syntax() -> Syntax {
        return SyntaxFactory.makeStringSegment(swiftCode())
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
