//
//  Sync.swift
//  CYaml
//
//  Created by Rob Saunders on 7/11/19.
//

import Foundation

extension Project {
	func syncSettings(spec: SwaggerSpec) -> [Result<String, Swift.Error>] {
		for server in spec.servers {

		}
		return [.success("Ok")]
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
