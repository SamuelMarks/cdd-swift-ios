//
//  Sync.swift
//  CYaml
//
//  Created by Rob Saunders on 7/11/19.
//

import Foundation

enum LogEntry {
	case success(String)
	case failure(String)
}

extension Project {

	func diff(against spec: SpecFile) {
		if spec.modificationDate.compare(self.info.modificationDate) == .orderedDescending {
			// spec is newer
			
		} else {
			// settings is newer
//			self.info = ProjectInfo(fromSpec: spec)
		}


//		if spec.servers.map({$0.url}).contains(self.info.hostname.absoluteString) {
//
//		}
	}

	func syncSettings(spec: SwaggerSpec) -> [Result<String, Swift.Error>] {


//		if self.info.hostname

		var results: [Result<String, Swift.Error>] = []

		if spec.servers.count > 1 {
			results.append(.failure(ProjectError.OpenAPIFile("only one server is supported in openapi.yml")))
		} else {

		}

		return results
	}

	func syncModels(spec: SwaggerSpec) -> Result<SwaggerSpec, Swift.Error> {
//		let specPaths =
//
//		for route in routes {
//			print("Syncing \(route)...")
//			print(spec.components)
//		}
		return .success(spec)
	}
}
