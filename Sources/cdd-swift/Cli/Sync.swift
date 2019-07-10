import Foundation
import SwiftCLI
import Rainbow

class SyncCommand: Command {
	let name = "sync"
	let shortDescription = "Synchronizes OpenAPI spec to a CDD-Swift project"

	func execute() throws {
		let projectReader = try! ProjectReader(path: "/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Template")

		printFileResults(fileResults: [projectReader.settingsSyntax])
		printFileResults(fileResults: projectReader.parsableFiles)

		switch projectReader.generateProject() {
		case .success(let project):
			print("[OK] Successfully generated project with \(project.models.count) models, \(project.routes.count) routes.".green)
			print(project)
		case .failure(let error):
			print("[Error] \(error.localizedDescription)".red)
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
