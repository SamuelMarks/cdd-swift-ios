//
//  ProjectReader.swift
//	- Responsible for understanding project directory structure and writing reading files

import Foundation
import Yams
import SwiftSyntax

let SPEC_FILE = "/openapi.yml"
let MODELS_DIR = "/Source/API/Models"
let REQUESTS_DIR = "/Source/API/Request"
let SETTINGS_FILE = "/Source/Settings.swift"

struct FileResult<T> {
	let fileName: String
	let modificationDate: Date
	let result: Result<T,Swift.Error>
}

class ProjectReader {
	let projectPath: String
	var specFile: SpecFile
	var settingsFile: SourceFile
	var modelFiles: [SourceFile]
//	var requestFiles: [SourceFile]

	init(path: String) throws {
		self.projectPath = path

		do {
			let specUrl = URL(fileURLWithPath: "\(self.projectPath + SPEC_FILE)")
			self.specFile = SpecFile(
				path: specUrl,
				modificationDate: try fileLastModifiedDate(url: specUrl),
				syntax: try SwaggerSpec.init(url: specUrl)
			)
			self.settingsFile = try SourceFile(path: "\(self.projectPath + SETTINGS_FILE)")

			if case let .success(projectFiles) = readDirectory(self.projectPath + MODELS_DIR) {
				self.modelFiles = try projectFiles.map({ file in
					do {
						log.infoMessage("MODEL source found: \(file)")
						return try SourceFile(path: file.path)
					} catch let err {
						throw err
					}
				})
			} else {
				self.modelFiles = []
			}

		} catch let error {
			throw error
		}
	}

	private func generateProject() -> Result<Project, Swift.Error> {
		guard case let .success(projectInfo) = parseProjectInfo(self.settingsFile) else {
			return .failure(
				ProjectError.InvalidSettingsFile("Cannot parse \(SETTINGS_FILE)"))
		}

		// todo: requests
		return .success(
			Project(
				info: projectInfo,
				models: parseModels(sourceFiles: self.modelFiles),
				requests: []
			))
	}

	/// generate an up to date project file from spec and source files.
    func merge() -> Result<Project, Swift.Error> {
		do {
			// generate a Project from swift files
			let swiftProject: Project = try self.generateProject().get()
			log.eventMessage("Generated project from swift project with \(swiftProject.models.count) models, \(swiftProject.requests.count) routes.".green)
			log.infoMessage("- source models: \(swiftProject.models.map({$0.name}))")

			// generate a Project from the openapi spec
			// todo: convert interface to .generateProject() -> Result
			let specProject: Project = Project.fromSwagger(self.specFile)!
			log.eventMessage("Generated project from spec with \(specProject.models.count) models, \(specProject.requests.count) routes.".green)
			log.infoMessage("- spec models: \(specProject.models.map({$0.name}))")

			// merge the projects with most recent data from each set
			// todo: fix spec to return properly
			let mergedProject = specProject.merge(with: swiftProject)

			return .success(mergedProject)
		} catch (let err) {
			return .failure(err)
		}
    }

	/// update spec and source files with a merged project
	func apply(project: Project) {

		// update ProjectInfo in spec file
		self.specFile.apply(projectInfo: project.info)

		// update ProjectInfo in Settings.swift
		self.settingsFile.update(projectInfo: project.info)

		// update spec file models:
		for model in project.models {
			// if model exists in spec file,
			if self.specFile.contains(model: model.name) {
				// write an update (non destructively update its variables and properties)
				self.specFile.update(model: model)
				log.eventMessage("Updated \(model.name) in \(self.specFile.path.path)")
			} else {
				// else insert it into the spec file
				self.specFile.insert(model: model)
				log.eventMessage("Inserted \(model.name) in \(self.specFile.path.path)")
			}

			let fileName = URL(string: "\(MODELS_DIR)/\(model.name).swift")!
			if fileExists(file: fileName.path) {
				if project.models.contains(where: {model.name == $0.name}) {
					log.errorMessage("UNIMPLEMENTED update model to source: \(model.name)")
				} else {
					log.errorMessage("UNIMPLEMENTED delete model from source: \(model.name)")
				}
			} else {
				self.modelFiles.append(SourceFile.create(path: fileName, model: model))
				log.eventMessage("Created \(fileName)")
			}
		}

		// update source file models:
		for modelFile in self.modelFiles {
			// for each model in the swift source,
			for model in parseModels(sourceFiles: [modelFile]) {
				// if the model is fresh, update it
				if project.models.contains(where: {$0.name == model.name}) {
					log.errorMessage("UNIMPLEMENTED add model to specfile: \(model.name)")
				} else {
					// else delete it
					log.errorMessage("UNIMPLEMENTED delete model from source file: \(model.name)")
				}
			}
		}

		// clean up additional models in spec
		for specModel in self.specFile.generateProject().models {
			if !project.models.contains(where: {$0.name == specModel.name}) {
				self.specFile.remove(model: specModel.name)
			}
		}
	}
}

extension Change {
    func objectName() -> String {
        switch self {
        case .deletion(let object):
           return object.objectName()
        case .insertion(let object):
          return object.objectName()
        case .update(let object):
           return object.objectName()
        }
    }
}

extension APIObjectChange {
    func objectName() -> String {
        switch self {
        case .model(let model, _):
            return model.name
        case .request(let request, _):
            return request.name
        }
    }
}
