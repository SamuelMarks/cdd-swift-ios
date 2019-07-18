import Foundation
import SwiftCLI

class SyncCommand: Command {
	let name = "sync"
	let shortDescription = "Synchronizes OpenAPI spec to a CDD-Swift project"
	//		let verbose = Flag("--verbose", "-v", description: "Show verbose output", defaultValue: false)
	//		let silent = Flag("--silent", "-s", description: "Silence standard output", defaultValue: false)
	//		let silent = Flag("--dry-run", "-d", description: "Dry run; no changes are written to disk", defaultValue: false)
	let spec = SwiftCLI.Parameter()

	func execute() throws {
		guard let specURL: URL = URL(string: spec.value) else {
			exitWithError("Must pass valid spec. It can be a path or a url")
		}

		sync(spec: specURL)
	}

	func sync(spec: URL) {

		do {
			let projectReader = try ProjectReader(path: spec.absoluteString)

			if case let .success(project) = projectReader.sync() {
				log.eventMessage("Generated merged project with \(project.models.count) models: \(project.models.map({$0.name}))")
				projectReader.apply(project: project)
			}

//			switch projectReader.generateProject() {
//
//			case .success(let project):
//				log.eventMessage("Successfully generated project from swift project with \(project.models.count) models, \(project.requests.count) routes.".green)
//				log.eventMessage("Swift models: \(project.models.map({$0.name}))")
//
//				if case let .success(project) = projectReader.sync() {
//					log.eventMessage("Generated merged project with \(project.models.count) models: \(project.models.map({$0.name}))")
//					projectReader.apply(project: project)
//				}
//
////				if case let .some(swaggerProject) = Project.fromSwagger(projectReader.specFile) {
////					for change in project.compare(swaggerProject) {
//////						print("changes: \(project.compare(swaggerProject))")
////						printChangeResult(change.apply())
////					}
////				}
//
//			case .failure(let error):
//				printError(error)
//			}

		} catch (let err) {
			exitWithError(err)
		}
	}
}
