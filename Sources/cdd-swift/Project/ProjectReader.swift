//
//  ProjectReader.swift
//	- Responsible for understanding project directory structure and writing reading files

import Foundation
import Yams
import SwiftSyntax

let SPEC_FILE = "/openapi.yml"
let MODELS_DIR = "/ios/API"
let SETTINGS_FILE = "/ios/Settings.swift"

struct FileResult<T> {
	let fileName: String
	let modificationDate: Date
	let result: Result<T,Swift.Error>
}

class ProjectReader {
	let projectPath: String
	var specFile: SpecFile
	var settingsFile: SourceFile
	var sourceFiles: [SourceFile]
    var classToSourceFile: [String:URL] = [:]

	init(path: String) throws {
		self.projectPath = path

		do {
			let specUrl = URL(fileURLWithPath: "\(self.projectPath)/\(SPEC_FILE)")
			self.specFile = SpecFile(
				path: specUrl,
				modificationDate: try fileLastModifiedDate(url: specUrl),
				syntax: try SwaggerSpec.init(url: specUrl)
			)
			self.settingsFile = try SourceFile(path: "\(self.projectPath + SETTINGS_FILE)")
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
				ProjectError.InvalidSettingsFile("Cannot parse \(SETTINGS_FILE)"))
		}

        let objects = parse(sourceFiles: self.sourceFiles)
        classToSourceFile = objects.2
		return .success(Project(
			info: projectInfo,
			models: objects.0,
			requests: objects.1
		))
	}

    func sync() -> Result<Project, Swift.Error> {
		do {
			// generate a Project from swift files
			let swiftProject = try self.generateProject().get()

			// generate a Project from the openapi spec
			// todo: convert interface to .generateProject() -> Result
			let specProject = Project.fromSwagger(self.specFile)

			// merge the projects with most recent data from each set
			// todo: fix spec to return properly
			let mergedProject = specProject!.merge(with: swiftProject)

			return .success(mergedProject)
		} catch (let err) {
			return .failure(err)
		}
    }

	func apply(project: Project) {

		// apply ProjectInfo to spec file
		self.specFile.apply(projectInfo: project.info)

		// iterate models and routes in specfile here

		// apply ProjectInfo to Settings.swift
		self.settingsFile.apply(projectInfo: project.info)

		for (index, file) in self.sourceFiles.enumerated() {
			// todo: clean syntax of parse()
			let (models, routes, _) = parse(sourceFiles: [file])

			for model in models {
				print("found model: \(model.name)")
				if project.models.contains(where: {$0.name == model.name}) {
					print("model is supposed to be in project")
					self.sourceFiles[index].apply(model: model)
				} else {
					// delete model
					self.sourceFiles[index].delete(model: model)
				}


//				if file.contains(model: model.name) {
//					print("in file: \(file.path)")
//				}
			}
			for route in routes {
				print("route: \(route.name)")
			}
		}
	}
    
    func writeToSwiftFiles(changes:[Change]) {
        for change in changes {
            if let url = classToSourceFile[change.objectName()],
                let _ = sourceFiles.first(where: {$0.path == url}) {
            }
        }
	}
    
    func writeToSwaggerFiles(changes:[Change]) {
//        self.specFile.syntax.apply(changes)
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
