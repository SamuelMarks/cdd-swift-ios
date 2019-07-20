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
    
    mutating func update(model: Model, changes: [VariableChange]) {
        for change in changes {
            switch change {
            case .deletion(let variable):
                log.errorMessage("UNIMPLEMENTED: delete(variable)")
            case .insertion(let variable):
                log.errorMessage("UNIMPLEMENTED: insert(variable)")
            }
        }
        
        for variable in model.vars {
            var varSyntax:Syntax! = nil/// need to implement
            guard let modelSyntax = find(model: model) else { return }
            let newModelSyntax = VariableRewriter.rewrite(name: variable.name, syntax: varSyntax, in: modelSyntax)
            self.syntax = ClassRewriter.rewrite(name: model.name, syntax: newModelSyntax, in: self.syntax)
        }
    }
    
    mutating func remove(request:Request) {
        log.errorMessage("UNIMPLEMENTED: remove(request)")
    }
    
    mutating func insert(request:Request) {
        log.errorMessage("UNIMPLEMENTED: insert(request)")
    }
    
    mutating func update(request:Request,changes:[VariableChange]) {
        log.errorMessage("UNIMPLEMENTED: update(request)")
    }
    
    
    func find(model: Model) -> StructDeclSyntax? {
        let visitor = ClassVisitor()
        syntax.walk(visitor)
        return visitor.syntaxes[model.name]
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

		for klass in visitor.klasses {
			if klass.interfaces.contains(MODEL_PROTOCOL) && klass.name == name {
				return true
			}
		}

		return false
	}
}
