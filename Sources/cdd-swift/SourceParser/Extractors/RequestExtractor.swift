//
//  RequestExtractor.swift
//  cdd-swift
//
//  Created by Alexei on 04/07/2019.
//

import SwiftSyntax

class RequestExtractor : SyntaxVisitor {
//    var variables: [VariableDeclaration] = []
//    var path: String?
//    var type: String?
//    var responseType: String?
//    
//    override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
//        
//        let f: String? = node.children.first(where: { child in
//            type(of: child) == IdentifierPatternSyntax.self
//        }).map({child in
//            "\(child)"
//        })
//        
//        let t = node.children.first(where: { child in
//            type(of: child) == TypeAnnotationSyntax.self
//        }).map({child in
//            "\((child as! TypeAnnotationSyntax).type)"
//        })
//        
//        if let fieldName = f, let fieldType = t {
//            variables.append(VariableDeclaration(variableName: fieldName, variableType: fieldType))
//        }
//        
//        return .skipChildren
//    }
}
