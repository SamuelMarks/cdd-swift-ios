//
//  Error.swift
//  CYaml
//
//  Created by Rob Saunders on 7/11/19.
//

import Foundation

enum ProjectError : Error {
	case InvalidSettingsFile(String)
	case InvalidHostname(String)

	var localizedDescription: String {
		switch self {
		case .InvalidHostname(let msg):
			return "Invalid hostname: \(msg)"
		case .InvalidSettingsFile(let msg):
			return "Invalid settings file: \(msg)"
		}
	}
}
