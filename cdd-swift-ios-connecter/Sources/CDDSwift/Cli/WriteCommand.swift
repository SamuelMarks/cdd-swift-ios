import Foundation
import SwiftCLI
import Willow

class WriteCommand: Command {
    enum SourceType: String {
        case model, request
    }
    enum OperationType: String {
        case insert,update,delete
    }
    
    let name: String
    let shortDescription: String
    let operation: OperationType
    let source: SourceType
    
    
    let projectPath = Key<String>("-p", "--project-path", description: "Manually specify a path to the project")
    
    let verbose = Flag("-v", "--verbose", description: "Show verbose output", defaultValue: false)
    //    let output = Key<String>("-f", "--output-file", description: "Output logging to file")
    
    
    init(operation: OperationType, source: SourceType) {
        self.operation = operation
        name = operation.rawValue + "-" + source.rawValue + "s"
        shortDescription = "\(operation.rawValue) \(source.rawValue) to swift sorce files"
        self.source = source
    }
    
    func execute() throws {
        
        if verbose.value {
            log.verbose()
        }
        
        if config.dryRun {
            log.infoMessage("CONFIG SETTING Dry run; no changes are written to disk")
        }
        
        if let path = projectPath.value {
            try write(projectPath: path, json: "")
        }
        else {
            if let pwd = ProcessInfo.processInfo.environment["PWD"] {
                try write(projectPath: pwd, json: "")
            }
        }
    }
    
    func write(projectPath: String, json:String) throws {
        do {
            let projectReader = try ProjectReader(projectPath: projectPath)
            
            switch operation {
            case .insert:
                switch source {
                case .model:
                    try projectReader.modelsFile.insert(model: Model.from(json: json))
                case .request:
                    try projectReader.requestsFile.insert(request: Request.from(json: json))
                }
            case .update:
                switch source {
                case .model:
                    try projectReader.modelsFile.update(model: Model.from(json: json))
                case .request:
                    try projectReader.requestsFile.update(request: Request.from(json: json))
                }
            case .delete:
                switch source {
                case .model:
                    projectReader.modelsFile.remove(name: json)
                case .request:
                    projectReader.requestsFile.remove(name: json)
                }
            }

            try projectReader.generateTests()
            projectReader.write()
            log.eventMessage("Project Readed")
        } catch let error as ProjectError {
            exitWithError(error.localizedDescription)
        } catch {
            exitWithError(error)
        }
    }
}
