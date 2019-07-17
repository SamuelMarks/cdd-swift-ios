//
//  SpecFile.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation

struct SpecFile {
	let path: URL
	let modificationDate: Date
	var syntax: SwaggerSpec

	mutating func apply(projectInfo: ProjectInfo) {
		let hostname = projectInfo.hostname.absoluteString
		if !self.syntax.servers.map({$0.url}).contains(projectInfo.hostname.absoluteString) {
			self.syntax.servers.append(Server(name: nil, url: hostname, description: nil, variables: [:]))
		}
	}
}
