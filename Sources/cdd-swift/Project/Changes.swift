//
//  Changes.swift
//  CYaml
//
//  Created by Rob Saunders on 7/15/19.
//

import Foundation

enum ChangeResult {
	case success(String)
	case failure(String)
}

extension Change {
	func apply() -> ChangeResult {
		switch self {
		case .insertion(_):
			return .success("done")
		case .deletion(_):
			return .success("done")
		case .update(let update):
			return update.apply()
		}
	}
}

extension APIObjectChange {
	func apply() -> ChangeResult {
		switch self {
		case .model(let model, let modelchange):
			print(model)
			return .success("done")
		case .request(let request, let requestChange):
//			request.update(requestChange)
			return .success("Updated \(request) with \(requestChange)")
		}
	}
}
