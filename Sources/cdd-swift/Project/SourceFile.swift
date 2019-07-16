//
//  SourceFile.swift
//  CYaml
//
//  Created by Rob Saunders on 7/15/19.
//

import Foundation

extension SourceFile {
	func apply(_ change: Change) -> SourceFile {
		switch change {
		case .insertion(let objectType):
			switch objectType {
			case .model(let model, let change):
//				if case let .some(change)
				()
//				model.compare(to: )
			case .request(let request, let change):
				()
			}
//			return .success("insertion")
			return self
		case .deletion(let objectType):
//			return .success("deletion")
			return self
		case .update(let objectType):
//			switch objectType {
//			case .model(let model, let change):
//				if let .some(change)
//			case .request(let request, let change):
//				()
//			}

			return self
		}
	}

	func apply(projectInfo: ProjectInfo) {
		
	}
}

