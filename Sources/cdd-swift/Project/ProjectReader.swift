//
//  ProjectReader.swift
//	- Responsible for understanding project directory structure and writing reading files

import Foundation
import Yams
import SwiftSyntax

let SPEC_FILE = "/openapi.yml"
let MODELS_DIR = "/ios/API"
let SETTINGS_DIR = "/ios"

struct FileResult<T> {
	let fileName: String
	let modificationDate: Date
	let result: Result<T,Swift.Error>
}

struct SourceFile {
	let path: URL
	let modificationDate: Date
	var syntax: SourceFileSyntax

	init(path: String) throws {
		do {
			let url = URL(fileURLWithPath: path)
			self.path = url
			self.modificationDate = try fileLastModifiedDate(url: url)
			self.syntax = try SyntaxTreeParser.parse(url)
		}
	}

	mutating func apply(projectInfo: ProjectInfo) -> Result<String, Swift.Error> {
		do {
			try self.renameVariable(varName: "HOST", varValue: projectInfo.hostname.absoluteString).get()
			
			return .success("successfully rewrote \(self.path.path)")
		} catch let err {
			return .failure(err)
		}
	}
}

struct SpecFile {
	let path: URL
	let modificationDate: Date
	let syntax: SwaggerSpec
}

class ProjectReader {
	let projectPath: String
	let specFile: SpecFile
	var settingsFile: SourceFile
	let sourceFiles: [SourceFile]

	init(path: String) throws {
		self.projectPath = path

		do {
			let specUrl = URL(fileURLWithPath: "\(self.projectPath)/\(SPEC_FILE)")
			self.specFile = SpecFile(
				path: specUrl,
				modificationDate: try fileLastModifiedDate(url: specUrl),
				syntax: try SwaggerSpec.init(url: specUrl)
			)
			self.settingsFile = try SourceFile(path: "\(self.projectPath + SETTINGS_DIR)/Settings.swift")
			self.sourceFiles = try [
				"\(self.projectPath + MODELS_DIR)/Test.swift"
			].map({ path in
				try SourceFile(path: path)
			})
		} catch let error {
			throw error
		}
	}

	func generateProject() -> Result<Project, Swift.Error> {
		guard case let .success(projectInfo) = parseProjectInfo(self.settingsFile) else {
			return .failure(
				ProjectError.InvalidSettingsFile("Cannot parse Settings.swift"))
		}

		return .success(Project(
			info: projectInfo,
			models: parseModels(sourceFiles: self.sourceFiles),
			requests: parseRequests(sourceFiles: self.sourceFiles)
		))
	}

	func writeProject() {
		// unimplemented
	}
}
