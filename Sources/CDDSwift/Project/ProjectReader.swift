//
//  ProjectReader.swift
//	- Responsible for understanding project directory structure and writing reading files

import Foundation
import Yams
import SwiftSyntax

let SPEC_FILE = "/openapi.yml"
let MODELS_DIR = "/iOS/$0/Source/API/APIModels.swift"
let REQUESTS_DIR = "/iOS/$0/Source/API/APIRequests.swift"
let SETTINGS_FILE = "/iOS/$0/Source/API/APISettings.swift"

protocol ProjectSource {
    mutating func remove(model:Model)
    mutating func insert(model:Model) throws
    mutating func update(model:Model)
    mutating func remove(request:Request)
    mutating func insert(request:Request) throws
    mutating func update(request:Request)
}

class ProjectReader {
    let projectPath: String
    var specFile: SpecFile
    var settingsFile: SourceFile
    var modelsFile: SourceFile
    var requestsFile: SourceFile
    
    init(projectPath: String, openAPIPath:String?) throws {
        self.projectPath = projectPath
        let openapiPath = openAPIPath ?? projectPath + SPEC_FILE
        do {
            let specUrl = URL(fileURLWithPath: openapiPath)
            self.specFile = SpecFile(
                path: specUrl,
                modificationDate: try fileLastModifiedDate(url: specUrl),
                syntax: try SwaggerSpec.init(url: specUrl)
            )
            let projectName = findProjectName(at: self.projectPath + "/IOS")
            log.infoMessage("Found project: " + projectName)
            self.settingsFile = try SourceFile(path: self.projectPath + SETTINGS_FILE.replacingOccurrences(of: "$0", with: projectName))
            
            self.modelsFile = try SourceFile(path: self.projectPath + MODELS_DIR.replacingOccurrences(of: "$0", with: projectName))
            self.requestsFile = try SourceFile(path: self.projectPath + REQUESTS_DIR.replacingOccurrences(of: "$0", with: projectName))
        }
    }
    
    func generateProject() throws -> Project {
        let projectInfo = try parseProjectInfo(self.settingsFile)
        let result = parse(sourceFiles: [modelsFile,requestsFile])
        
        return Project(info: projectInfo, models: result.0, requests: result.1)
    }

	/// attempt to generate unit tests for generated requests
	func generateTests() throws {
		let swiftProject = try self.generateProject()
		let projectName = guessProjectName()
		print(buildTestClass(from: swiftProject.requests, projectName: projectName))
	}
    
    func sync() throws {
        // generate a Project from swift files
        let swiftProject = try self.generateProject()
        
        log.eventMessage("Generated project from swift project with \(swiftProject.models.count) models, \(swiftProject.requests.count) routes.".green)
        log.infoMessage("- source models: \(swiftProject.models.map({$0.name}))")
        log.infoMessage("- source requests: \(swiftProject.requests.map({$0.name}))")
        // generate a Project from the openapi spec
        // todo: convert interface to .generateProject() -> Result
        let specProject: Project = Project.fromSwagger(self.specFile)!
        log.eventMessage("Generated project from spec with \(specProject.models.count) models, \(specProject.requests.count) routes.".green)
        log.infoMessage("- spec models: \(specProject.models.map({$0.name}))")
        log.infoMessage("- spec project requests: \(specProject.requests.map({$0.name}))")
        // merge the projects with most recent data from each set
        // todo: fix spec to return properly

        let mergedProject = specProject.merge(with: swiftProject)
        
        log.eventMessage("Merged project with \(mergedProject.models.count) models, \(mergedProject.requests.count) routes.".green)
        log.infoMessage("- Merged project models: \(mergedProject.models.map({$0.name}))")
        log.infoMessage("- Merged project requests: \(mergedProject.requests.map({$0.name}))")
        
        self.specFile.apply(projectInfo: mergedProject.info)
        self.settingsFile.update(projectInfo: mergedProject.info)
        
        let modelsChanges = mergedProject.models.compare(to: specProject.models)
        for change in modelsChanges {
            switch change {
            case .deletion(let model):
                specFile.remove(model: model)
            case .insertion(let model):
                specFile.insert(model: model)
            case .same(let model):
                specFile.update(model: model)
            }
        }
        
        let requestsChanges = mergedProject.requests.compare(to: specProject.requests)
        for change in requestsChanges {
            switch change {
            case .deletion(let request):
                specFile.remove(request: request)
            case .insertion(let request):
                specFile.insert(request: request)
            case .same(let request):
                specFile.update(request: request)
            }
        }
        
        let modelsChanges1 = mergedProject.models.compare(to: swiftProject.models)
        for change in modelsChanges1 {
            var sourceFile = modelsFile
            switch change {
            case .deletion(let model):
                sourceFile.remove(model:model)
            case .insertion(let model):
                try sourceFile.insert(model:model)
            case .same(let model):
               sourceFile.update(model:model)
            }
            modelsFile = sourceFile
        }
        
        let requestsChanges1 = mergedProject.requests.compare(to: swiftProject.requests)
        for change in requestsChanges1 {
            var sourceFile = requestsFile
            
            switch change {
            case .deletion(let request):
                sourceFile.remove(request: request)
            case .insertion(let request):
                try sourceFile.insert(request: request)
            case .same(let request):
                sourceFile.update(request: request)
            }
            requestsFile = sourceFile
        }
    }
    
    func write() -> Result<(), Swift.Error> {
        do {
            // write specfile
            let yaml = try self.specFile.toYAML().get()
            let _ = writeStringToFile(file: self.specFile.path, contents: "\(yaml)")

            // write models
			for sourceFile in [modelsFile,requestsFile] {
				logFileWrite(
					result: writeStringToFile(file: sourceFile.url, contents: "\(sourceFile.syntax)"),
					filePath: sourceFile.url.path)
			}
        } catch let err {
            return .failure(err)
        }

		return .success(())
    }

	func guessProjectName() -> String {
		if case let .success(files) = readDirectory(self.projectPath + "/iOS") {
			for file in files {
				if file.pathExtension == "xcodeproj" {
					var file = file
					file.deletePathExtension()
					return file.lastPathComponent
				}
			}
			return "hi"
		}

		return "MyProject"
	}
}

func logFileWrite(result: Result<(), Swift.Error>, filePath: String) {
	switch result {
	case .success(_):
		log.eventMessage("WROTE \(filePath)")
	case .failure(let err):
		log.errorMessage("ERROR WRITING \(filePath): \(err)")
	}
}
