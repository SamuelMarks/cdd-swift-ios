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

//	mutating func apply(projectInfo: ProjectInfo) -> Result<String, Swift.Error> {
//		do {
//			try self.renameVariable(varName: "HOST", varValue: projectInfo.hostname.host!).get()
//			try self.renameVariable(varName: "ENDPOINT", varValue: projectInfo.hostname.path).get()
//
//			return .success("successfully rewrote \(self.path.path)")
//		} catch let err {
//			return .failure(err)
//		}
//	}
}

struct SpecFile {
	let path: URL
	let modificationDate: Date
    var syntax: SwaggerSpec
}

class ProjectReader {
	let projectPath: String
	var specFile: SpecFile
	var settingsFile: SourceFile
	let sourceFiles: [SourceFile]
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
			let projectFiles = try self.generateProject().get()

			// todo: convert interface to .generateProject() -> Result
			let spec = Project.fromSwagger(self.specFile)

			// todo: fix spec to return properly
			let mergedProject = spec!.merge(with: projectFiles)

			// apply project

			// apply settings file
			self.settingsFile.apply(projectInfo: mergedProject.info)
			print(self.settingsFile)


//			print(mergedProject)

//			for file in self.sourceFiles {
//				if file.modificationDate.compare(self.specFile.modificationDate) == .orderedAscending {
//					print("file \(file.modificationDate) is older than spec \(self.specFile.modificationDate)")
//
//					let (models, requests, _) = parse(sourceFiles: [file])
//					for model in spec.models {
//
//					}
//
//				} else {
//					print("file \(file.modificationDate) is newer than spec \(self.specFile.modificationDate)")
//					// todo: clean this.
//					let (models, requests, _) = parse(sourceFiles: [file])
//					for model in models {
//						if case let .some(model) = model.find(in: models) {
//							// model is in this m
////							model.compare(to: <#T##Model#>)
//						}
//					}
//				}
//			}

			return .success(mergedProject)
		} catch (let err) {
			return .failure(err)
		}


//        let project:Project = try! self.generateProject().get()
//        let specProject:Project = try! Project.fromSwagger(self.specFile.syntax)!
//
//        let changes = specProject.compare(project)
//		printSuccess("found \(changes.count) changes to write to swift project.")
//
//        writeToSwiftFiles(changes: changes)
//
//
//        let changes2 = project.compare(specProject)
//
//        writeToSwaggerFiles(changes: changes2)
    }
    
    func writeToSwiftFiles(changes:[Change]) {
        for change in changes {
            if let url = classToSourceFile[change.objectName()],
                let sourceFile = sourceFiles.first(where: {$0.path == url}) {
//                apply(change: change, to: sourceFile)

				sourceFile.apply(change)
            }
        }
	}
    
    func writeToSwaggerFiles(changes:[Change]) {
        self.specFile.syntax.apply(changes)
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
