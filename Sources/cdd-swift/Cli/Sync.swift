import Foundation
import SwiftCLI

class SyncCommand: Command {
	let name = "sync"
	let shortDescription = "Synchronizes OpenAPI spec to a CDD-Swift project"
	//		let verbose = Flag("--verbose", "-v", description: "Show verbose output", defaultValue: false)
	//		let silent = Flag("--silent", "-s", description: "Silence standard output", defaultValue: false)
	let silent = Flag("--dry-run", "-d", description: "Dry run; no changes are written to disk", defaultValue: false)
    let projectPath = Key<String>("-p", "--project-path", description: "Manually specify a path to output the project")
    let isVerbose = Key<String>("-v", "--verbose", description: "Verbosity selection")
	func execute() throws {
        
        if config.dryRun {
            log.infoMessage("CONFIG SETTING Dry run; no changes are written to disk")
        }
        
        if silent.value {
            config.dryRun = true
        }

        if let path = projectPath.value {
            sync(path: path)
        }
        else {
            if let pwd = ProcessInfo.processInfo.environment["PWD"] {
                sync(path: pwd)
            }
        }
	}

    func sync(path:String) {
		do {
			let projectReader = try ProjectReader(path: path)
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
