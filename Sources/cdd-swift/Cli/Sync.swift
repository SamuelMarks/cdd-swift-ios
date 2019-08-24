import Foundation
import SwiftCLI

class SyncCommand: Command {
	let name = "sync"
	let shortDescription = "Synchronizes OpenAPI spec to a CDD-Swift project"
	//		let verbose = Flag("--verbose", "-v", description: "Show verbose output", defaultValue: false)
	//		let silent = Flag("--silent", "-s", description: "Silence standard output", defaultValue: false)
	let silent = Flag("--dry-run", "-d", description: "Dry run; no changes are written to disk", defaultValue: false)
	let spec = SwiftCLI.Parameter()

	func execute() throws {
		guard let specURL: URL = URL(string: spec.value) else {
			exitWithError("Must pass valid spec. It can be a path or a url")
		}

		if silent.value {
			config.dryRun = true
		}

		if config.dryRun {
			log.infoMessage("CONFIG SETTING Dry run; no changes are written to disk")
		}

		sync(spec: specURL)
	}

	func sync(spec: URL) {
		do {
			let projectReader = try ProjectReader(path: spec.absoluteString)
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
