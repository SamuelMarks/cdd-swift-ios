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
	let syntax: SourceFileSyntax

	init(path: String) throws {
		do {
			let url = URL(fileURLWithPath: path)
			self.path = url
			self.modificationDate = try fileLastModifiedDate(url: url)
			self.syntax = try SyntaxTreeParser.parse(url)
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
	let settingsFile: SourceFile
	let sourceFiles: [SourceFile]

//	let openapiDoc: SwaggerSpec
//	let openapiDocDate: Date
//	let settingsSyntax: FileResult<SourceFileSyntax>
//	let parsableFiles: [FileResult<SourceFileSyntax>]

	init(path: String) throws {
		self.projectPath = path

//		let specPath = "\(self.projectPath)/\(SPEC_FILE)"
//		guard let specUrl = URL(fileURLWithPath: specPath) else {
//			throw ProjectError.InvalidSettingsFile("invalid settings file: \(specPath)")
//		}

		do {
			let specUrl = URL(fileURLWithPath: "\(self.projectPath)/\(SPEC_FILE)")
			self.specFile = SpecFile(
				path: specUrl,
				modificationDate: try fileLastModifiedDate(url: specUrl),
				syntax: try SwaggerSpec.init(url: specUrl)
			)
			self.settingsFile = try SourceFile(path: "\(self.projectPath + SETTINGS_DIR)/Settings.swift")
			self.sourceFiles = try [
				"\(self.projectPath + MODELS_DIR)/API.swift"
			].map({ path in
				try SourceFile(path: path)
			})
		} catch let error {
			throw error
		}

//		self.openapiDoc = try readOpenApi(path: path)
//		self.openapiDocDate = fileLastModifiedDate(file: path)!
//		settingsSyntax = fileToSyntax("\(self.projectPath + SETTINGS_DIR)/Settings.swift")
//		parsableFiles = [
//			"\(self.projectPath + MODELS_DIR)/API.swift"
//		].map({ file in
//			fileToSyntax(file)
//		})
	}

	func generateProject() -> Result<Project, Swift.Error> {

		guard case let .success(projectInfo) = parseProjectInfo(self.settingsFile) else {
			return .failure(
				ProjectError.InvalidSettingsFile("Cannot parse Settings.swift"))
		}

		return .success(Project(
			info: projectInfo,
			models: parseModels(sourceFiles: self.sourceFiles),
			routes: parseRoutes(sourceFiles: self.sourceFiles)
		))

////		let syntaxes:[SourceFileSyntax] = self.sourceFiles.map({ result in
////			return try! result.result.get()
////		})
//
//		guard case let .success(settingsSyntax) = settingsSyntax.result else {
//			return .failure(
//				ProjectError.InvalidSettingsFile("Cannot parse Settings.swift"))
//		}
//
//		return parseProjectInfo(syntax: settingsSyntax, modificationDate: self.settingsSyntax.modificationDate).map({ projectInfo in
//			Project(
//				info: projectInfo,
//				models: parseModels(syntaxes: syntaxes),
//				routes: parseRoutes(syntaxes: syntaxes)
//			)
//		})
	}

	func writeProject() {
		// unimplemented
	}
}

func fileToSyntax(_ file: String) -> FileResult<SourceFileSyntax> {
	do {
		let syntax = try SyntaxTreeParser.parse(URL(fileURLWithPath: file))
		let modificationDate = fileLastModifiedDate(file: file)!
		return FileResult(fileName: file, modificationDate: modificationDate, result: .success(syntax))
	}
	catch let error {
		return FileResult(fileName: file, modificationDate: Date(), result: .failure(error))
	}
}

//func readOpenApi(path: String) throws -> SwaggerSpec {
//	// note: should look for json first, in default location. CHANGEME
//	let url = URL(fileURLWithPath: path + "/" + SPEC_FILE)
//
//	let data: Data
//	do {
//		data = try Data(contentsOf: url)
//	} catch {
//		throw SwaggerError.loadError(url)
//	}
//
//	if let string = String(data: data, encoding: .utf8) {
//		return try SwaggerSpec.init(string: string)
//	} else if let string = String(data: data, encoding: .ascii) {
//		return try SwaggerSpec.init(string: string)
//	} else {
//		throw SwaggerError.parseError("Swagger doc is not utf8 or ascii encoded")
//	}
//}
