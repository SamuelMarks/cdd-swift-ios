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

protocol ProjectSource {
    mutating func remove(model:Model)
    mutating func insert(model:Model)
    mutating func update(model:Model,changes:[VariableChange])
    mutating func remove(request:Request)
    mutating func insert(request:Request)
    mutating func update(request:Request,changes:[VariableChange])
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
                        return try SourceFile(path: file.path)
                    } catch let err {
                        throw err
                    }
                })
            } else {
                self.sourceFiles = []
            }
            
            // todo: incomplete Requests
            
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
                models: parseModels(sourceFiles: self.sourceFiles),
                requests: []
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
        
        let projectInfo = swiftProject.info.merge(with: specProject.info)
        self.specFile.apply(projectInfo: projectInfo)
        self.settingsFile.update(projectInfo: projectInfo)
        
        let changesForSpec = swiftProject.compare(specProject)
        for change in changesForSpec {
            self.specFile = apply(change: change, to: self.specFile)
        }
        
        let changesForSource = specProject.compare(swiftProject)
        for change in changesForSource {
            var path = ""
            var name = ""
            switch change {
            case .model(let model, _):
                path = "\(MODELS_DIR)/\(model.name).swift"
                name = model.name
            case .request(let request, _):
                path = "\(REQUESTS_DIR)/\(request.name).swift"
                name = request.name
            }
            
            if !fileExists(file: path), let file = SourceFile.create(path: path, name: name) {
                self.sourceFiles.append(file)
            }
            if let index = self.sourceFiles.firstIndex(where: {$0.containsClassWith(name: name)}) {
                self.sourceFiles[index] = apply(change: change, to: self.sourceFiles[index])
            }
        }
    }
    
    func apply<T:ProjectSource>(change: ProjectChange, to source:T) -> T {
        var source = source
        switch change {
        case .model(let model, let change):
            switch change {
            case .deletion:
                source.remove(model: model)
            case .insertion:
                source.insert(model: model)
            case .update(_):
                log.errorMessage("UNIMPLEMENTED: update \(model.name) in specfile")
            }
            break
        case .request(let request, let change):
            switch change {
            case .deletion:
                log.errorMessage("UNIMPLEMENTED delete request to source: \(request.name)")
            case .insertion:
                log.errorMessage("UNIMPLEMENTED insert request to source: \(request.name)")
            case .update(_):
                log.errorMessage("UNIMPLEMENTED update request to source: \(request.name)")
            }
            break
        }
        return source
    }
    
    func write() {
        do {
            // write specfile
            let yaml = try self.specFile.toYAML().get()
            writeStringToFile(file: self.specFile.path, contents: "\(yaml)")
            
            // write models
            // ...
        } catch let err {
            log.errorMessage("\(err)")
        }
    }
}
