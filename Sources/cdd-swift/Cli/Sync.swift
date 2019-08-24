import Foundation
import SwiftCLI
import Willow

class SyncCommand: Command {
	let name = "sync"
	let shortDescription = "Synchronizes OpenAPI spec to a CDD-Swift project"
	let silent = Flag("--dry-run", "-d", description: "Dry run; no changes are written to disk", defaultValue: false)
    let projectPath = Key<String>("-p", "--project-path", description: "Manually specify a path to the project")
    let openapiPath = Key<String>("-o", "--openapi-path", description: "Manually specify a path to openapi file")
    let verbose = Flag("-v", "--verbose", description: "Show verbose output", defaultValue: false)
    let output = Key<String>("-f", "--output-file", description: "Output logging to file")
   func execute() throws {
    
    
    if let path = output.value {
        log.enableFileOutput(path: path)
    }
    
    if config.dryRun {
        log.infoMessage("CONFIG SETTING Dry run; no changes are written to disk")
    }
    
    if silent.value {
            config.dryRun = true
        }

        if let path = projectPath.value {
            sync(projectPath: path)
        }
        else {
            if let pwd = ProcessInfo.processInfo.environment["PWD"] {
                sync(projectPath: pwd)
            }
        }
	}

    func sync(projectPath:String) {
		do {
			let projectReader = try ProjectReader(projectPath: projectPath, openAPIPath: openapiPath.value)
            try projectReader.sync()
            log.eventMessage("Project Synced")
			if case .success(_) = projectReader.write() {
				log.eventMessage("Successfully wrote project files.")
			}
		} catch (let err) {
			exitWithError(err)
		}
	}
}
