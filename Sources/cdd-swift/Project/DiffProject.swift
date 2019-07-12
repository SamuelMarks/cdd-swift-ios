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



extension ProjectReader {

	func diff(against project: Project) {
		// Settings.swift
		if self.specFile.modificationDate.compare(project.info.modificationDate) == .orderedDescending {
			// spec is newer
			try self.settingsFile.apply(projectInfo: project.info)
		} else {
			// settings.swift is newer
			try self.settingsFile.apply(projectInfo: project.info)
//			self.specFile.syntax.info.update(projectInfo: project.info)
		}

		// models

		

		// requests
	}

//	func diff(against spec: SpecFile) -> Project {
//		var newProject = self
//
//		if spec.modificationDate.compare(self.info.modificationDate) == .orderedDescending {
//
//			// spec is newer
//			let hostname = URL(string: spec.syntax.servers.first!.url)!
//			newProject.info = ProjectInfo(modificationDate: spec.modificationDate, hostname: hostname)
//
//		} else {
//
//			// settings is newer
//
//		}
//
//		return newProject
//	}
}
