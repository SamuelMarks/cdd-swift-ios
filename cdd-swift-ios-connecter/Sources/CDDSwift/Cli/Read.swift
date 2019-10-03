import Foundation
import SwiftCLI
import Willow

class ReadCommand: Command {
    let name = "read"
    let shortDescription = "Parsing swift sorce files to Project objects"
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
            read(projectPath: path)
        }
        else {
            if let pwd = ProcessInfo.processInfo.environment["PWD"] {
                read(projectPath: pwd)
            }
        }
    }
    
    func read(projectPath:String) {
        do {
            let projectReader = try ProjectReader(projectPath: projectPath)
            let jsonString = try projectReader.read().json()
            log.eventMessage("Project Readed")
        } catch let error as ProjectError {
            exitWithError(error.localizedDescription)
        } catch {
            exitWithError(error)
        }
    }
}
