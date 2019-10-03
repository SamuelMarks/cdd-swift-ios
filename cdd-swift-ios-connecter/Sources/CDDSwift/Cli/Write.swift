import Foundation
import SwiftCLI
import Willow

class WriteCommand: Command {
    let name = "write"
    let shortDescription = "Writing Project objects to swift sorce files"
    let projectPath = Key<String>("-p", "--project-path", description: "Manually specify a path to the project")
    
    let verbose = Flag("-v", "--verbose", description: "Show verbose output", defaultValue: false)
    //    let output = Key<String>("-f", "--output-file", description: "Output logging to file")
    
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
            let project = try Project.from(json: json)
            let projectReader = try ProjectReader(projectPath: projectPath)
            try projectReader.write(project: project)
            try projectReader.generateTests()
            log.eventMessage("Project Readed")
        } catch let error as ProjectError {
            exitWithError(error.localizedDescription)
        } catch {
            exitWithError(error)
        }
    }
}
