import Foundation
import SwiftCLI
import Rainbow

class SyncCommand: Command {
	let name = "sync"
	let shortDescription = "Synchronizes OpenAPI spec to a CDD-Swift project"
	//		let verbose = Flag("--verbose", "-v", description: "Show verbose output", defaultValue: false)
	//		let silent = Flag("--silent", "-s", description: "Silence standard output", defaultValue: false)
	let spec = SwiftCLI.Parameter()

	func execute() throws {
		guard let specURL: URL = URL(string: spec.value) else {
			exitWithError("Must pass valid spec. It can be a path or a url")
		}

		sync(spec: specURL)
	}

	func sync(spec: URL) {

		do {
			var projectReader = try ProjectReader(path: spec.absoluteString)

			switch projectReader.generateProject() {

			case .success(let project):
				printSuccess("Successfully generated project with \(project.models.count) models, \(project.requests.count) routes.")

				projectReader.diff(against: project)
//				projectReader.write()
//				let spec = project.diff(against: projectReader.specFile)


			case .failure(let error):
				printError(error)
			}

		} catch (let err) {
			exitWithError(err)
		}
	}
}

func printResult<T>(fileName: String, result: Result<T, Swift.Error>) {
	switch result {
	case .success(_):
		print("[OK] Parsed \(fileName)".green)
	case .failure(let error):
		print("[Error] parsing: \(fileName):\n\(error.localizedDescription)".red)
	}
}

func printFileResults<T>(fileResults: [FileResult<T>]) {
	for fileResult in fileResults {
		printResult(fileName: fileResult.fileName, result: fileResult.result)
	}
}

func printSuccess(_ string: String) {
	print("[OK] \(string)".green)
}

func exitWithError(_ string: String) -> Never {
	print("[Error] \(string)".red)
	exit(EXIT_FAILURE)
}

func exitWithError(_ error: Swift.Error) -> Never {
	print("[Error] \(error)".red)
	exit(EXIT_FAILURE)
}

// todo: not printing localisedDescription correctly
func printError(_ error: Swift.Error) {
	print("[Error] \(error)".red)
}
