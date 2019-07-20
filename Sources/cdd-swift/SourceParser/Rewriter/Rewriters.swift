//
//  Rewriters.swift
//  cdd-swift
//
//  Created by Alexei on 19/07/2019.
//



import Foundation
import SwiftSyntax

public class ClassRewriter: SyntaxRewriter {
    static func rewrite(name: String, syntax:Syntax, in sourceFileSyntax:SourceFileSyntax) -> SourceFileSyntax {
        let rewriter = ClassRewriter()
        rewriter.syntax = syntax
        rewriter.name = name
        return rewriter.visit(sourceFileSyntax) as! SourceFileSyntax
    }
    var syntax: Syntax!
    var name: String!
    override public func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        let visitor = ClassVisitor()
        node.walk(visitor)
        if visitor.klasses.first?.name == name {
            return syntax as! DeclSyntax
        }
        return node
    }
}

public class VariableRewriter: SyntaxRewriter {
    static func rewrite(name: String, syntax:Syntax, in mainSyntax:Syntax) -> Syntax {
        let rewriter = VariableRewriter()
        rewriter.syntax = syntax
        rewriter.name = name
        return rewriter.visit(mainSyntax)
    }
    var syntax: Syntax!
    var name: String!
    override public func visit(_ node: PatternBindingSyntax) -> Syntax {
        if node.child(at: 0)?.description == name {
            return syntax
        }
        return node
    }
}

public class VariableInsert: SyntaxRewriter {
	
}
