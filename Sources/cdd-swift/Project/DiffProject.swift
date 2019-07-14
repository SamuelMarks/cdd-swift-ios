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

	func diff() -> Project {
		var info: ProjectInfo
		var models:[Model] = []
		var requests:[Request] = []
		let project:Project = self.generateProject()
		let specProject:Project = self.specFile.generateProject()

		// Settings.swift
		if self.specFile.modificationDate.compare(project.info.modificationDate) == .orderedDescending {
			// spec is newer
//			try self.settingsFile.apply(projectInfo: project.info)
			info = specProject.info
		} else {
			// settings.swift is newer
//			try self.settingsFile.apply(projectInfo: project.info)
//			self.specFile.syntax.info.update(projectInfo: project.info)
			info = project.info
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
