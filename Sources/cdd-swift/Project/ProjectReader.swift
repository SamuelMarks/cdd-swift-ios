//
//  ProjectReader.swift
//	- Responsible for understanding project directory structure and writing reading files

import Foundation
import Yams
import SwiftSyntax

let SPEC_FILE = "/openapi.yml"
let MODELS_DIR = "/Source/API/Models"
let REQUESTS_DIR = "/Source/API/Requests"
let SETTINGS_FILE = "/Source/Settings.swift"

protocol ProjectSource {
    mutating func remove(model:Model)
    mutating func insert(model:Model)
    mutating func update(model:Model)
    mutating func remove(request:Request)
    mutating func insert(request:Request)
    mutating func update(request:Request)
}


class ProjectReader {
    let projectPath: String
    var specFile: SpecFile
    var settingsFile: SourceFile
    var sourceFiles: [SourceFile]
    
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
                self.sourceFiles = try projectFiles.map({ file in
                    do {
                        log.infoMessage("MODEL source found: \(file)")
                        return try SourceFile(path: file.path )
                    } catch let err {
                        throw err
                    }
                })
            } else {
                self.sourceFiles = []
            }
            
            if case let .success(projectFiles) = readDirectory(self.projectPath + REQUESTS_DIR) {
                let requestsSourceFiles: [SourceFile] = try projectFiles.map({ file in
                    do {
                        log.infoMessage("REQUEST source found: \(file)")
                        return try SourceFile(path: file.path)
                    } catch let err {
                        throw err
                    }
                })
                self.sourceFiles.append(contentsOf:requestsSourceFiles)
            } else {
//                self.sourceFiles = []
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
        
        let result = parse(sourceFiles: sourceFiles)
        // todo: requests
        return .success(
            Project(
                info: projectInfo,
                models: result.0,
                requests: result.1
        ))
    }
    
    func sync() throws  {
        // generate a Project from swift files
        let swiftProject = try self.generateProject().get()
        
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
            guard let index = indexFileFor(object: change.object()) else { return }
            var sourceFile = sourceFiles[index]
            switch change {
            case .deletion(let model):
                sourceFile.remove(model:model)
            case .insertion(let model):
                sourceFile.insert(model:model)
            case .same(let model):
               sourceFile.update(model:model)
            }
            sourceFiles[index] = sourceFile
        }
        
        let requestsChanges1 = mergedProject.requests.compare(to: swiftProject.requests)
        for change in requestsChanges1 {
            guard let index = indexFileFor(object: change.object()) else { return }
            var sourceFile = sourceFiles[index]
            
            switch change {
            case .deletion(let request):
                sourceFile.remove(request: request)
            case .insertion(let request):
                sourceFile.insert(request: request)
            case .same(let request):
                sourceFile.update(request: request)
            }
            sourceFiles[index] = sourceFile
        }
    }
    
    func indexFileFor(object: ProjectObject) -> Int? {
        var path = ""
        var name = ""
        if object is Model {
            path = "\(MODELS_DIR)/\(object.name).swift"
            name = object.name
        }
        else if object is Request {
            path = "\(REQUESTS_DIR)/\(object.name).swift"
            name = object.name
        }
        path = self.projectPath + path
        if !fileExists(file: path), let file = SourceFile.create(path: path, name: name) {
            self.sourceFiles.append(file)
        }
        if let index = self.sourceFiles.firstIndex(where: {$0.containsClassWith(name: name)}) {
            return index
        }
        
        return nil
    }
    
    func write() -> Result<(), Swift.Error> {
        do {
            // write specfile
            let yaml = try self.specFile.toYAML().get()
            let _ = writeStringToFile(file: self.specFile.path, contents: "\(yaml)")

            // write models
			for sourceFile in self.sourceFiles {
				logFileWrite(
					result: writeStringToFile(file: sourceFile.path, contents: "\(sourceFile.syntax)"),
					filePath: sourceFile.path.path)
			}
        } catch let err {
            return .failure(err)
        }

		return .success(())
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
