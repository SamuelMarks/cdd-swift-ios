//
//  ProjectReader.swift
//	- Responsible for understanding project directory structure and writing reading files

import Foundation
import Yams
import SwiftSyntax

let SPEC_FILE = "/openapi.yml"
let MODELS_DIR = "/ios/API"
let SETTINGS_DIR = "/ios"

func fileToSyntax(_ file: String) -> FileResult<SourceFileSyntax> {
	do {
		let syntax = try SyntaxTreeParser.parse(URL(fileURLWithPath: file))
		return FileResult(fileName: file, result: .success(syntax))
	}
	catch let error {
		return FileResult(fileName: file, result: .failure(error))
	}
}

func readOpenApi(_ path: String) throws -> SwaggerSpec {
	// note: should look for json first, in default location. CHANGEME
	let url = URL(fileURLWithPath: path + "/" + SPEC_FILE)

	let data: Data
	do {
		data = try Data(contentsOf: url)
	} catch {
		throw SwaggerError.loadError(url)
	}

	if let string = String(data: data, encoding: .utf8) {
		return try SwaggerSpec.init(string: string)
	} else if let string = String(data: data, encoding: .ascii) {
		return try SwaggerSpec.init(string: string)
	} else {
		throw SwaggerError.parseError("Swagger doc is not utf8 or ascii encoded")
	}
}

struct FileResult<T> {
	let fileName: String
	let result: Result<T,Swift.Error>
}

class ProjectReader {
	let openapiDoc: SwaggerSpec
	let path: String
	let settingsSyntax: FileResult<SourceFileSyntax>
	let parsableFiles: [FileResult<SourceFileSyntax>]

	init(path: String) throws {
		self.path = path
		print("reading \(path)...")

		self.openapiDoc = try readOpenApi(path)
		print("read openapi.yml")

		settingsSyntax = fileToSyntax("\(self.path + SETTINGS_DIR)/Settings.swift")
		parsableFiles = [
			"\(self.path + MODELS_DIR)/API.swift"
		].map({ file in
			fileToSyntax(file)
		})
	}

	func generateProject() -> Result<Project, Swift.Error> {
		let syntaxes:[SourceFileSyntax] = self.parsableFiles.map({ result in
			return try! result.result.get()
		})

		guard case let .success(settingsSyntax) = settingsSyntax.result else {
			return .failure(
				ProjectError.InvalidSettingsFile("Cannot parse Settings.swift"))
		}

		return parseProjectInfo(syntax: settingsSyntax).map({ projectInfo in
			Project(
				info: projectInfo,
				models: parseModels(syntaxes: syntaxes),
				routes: parseRoutes(syntaxes: syntaxes)
			)
		})
	}

	func writeProject() {
		// unimplemented
	}
}
