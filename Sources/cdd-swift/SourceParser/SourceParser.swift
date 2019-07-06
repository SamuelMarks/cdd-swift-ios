//
//  SourceParser.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation
import SwiftSyntax

func ParseSource(_ file: String) -> Project {
	return Project(models: [], routes: [])
}

func fileToSyntax(_ file: String) -> Result<SourceFileSyntax, Swift.Error> {
	do {
		let syntax = try SyntaxTreeParser.parse(URL(fileURLWithPath: file))
		return .success(syntax)
	}
	catch let error {
		return .failure(error)
	}
}
