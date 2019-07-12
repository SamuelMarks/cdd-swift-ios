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
	func diff(against spec: SpecFile) -> Project {
		var newProject = self

		if spec.modificationDate.compare(self.info.modificationDate) == .orderedDescending {

			// spec is newer
			let hostname = URL(string: spec.syntax.servers.first!.url)!
			newProject.info = ProjectInfo(modificationDate: spec.modificationDate, hostname: hostname)

		} else {

			// settings is newer

		}

		return newProject
	}
}
