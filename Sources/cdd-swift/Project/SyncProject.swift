//
//  Sync.swift
//  CYaml
//
//  Created by Rob Saunders on 7/11/19.
//

import Foundation

extension Project {
	func syncModels(spec: SwaggerSpec) -> Result<SwaggerSpec, Swift.Error> {
		for model in models {
			print("Syncing \(model)...")
		}
		return .success(spec)
	}
}
