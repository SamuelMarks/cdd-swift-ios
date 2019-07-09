import Foundation
import SwiftCLI
import Rainbow

class SyncCommand: Command {
	let name = "sync"
	let shortDescription = "Synchronizes openapi document to swift files"

	func execute() throws {
		let projectReader = try! ProjectReader(path: "/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Template")

		printResult(fileResults: [projectReader.settingsSyntax])
		printResult(fileResults: projectReader.parsableFiles)

		print(projectReader.generateProject())
	}
}

func printResult<T>(fileName: String, result: Result<T, Swift.Error>) {
	switch result {
	case .success(_):
		print("Parsed \(fileName)".green)
	case .failure(let error):
		print("Error parsing: \(fileName)\n\(error.localizedDescription)".red)
	}
}

func printResult<T>(fileResults: [FileResult<T>]) {
	for fileResult in fileResults {
		switch fileResult.result {

		case .success(let file):
			print("Parsed \(fileResult.fileName)".green)

		case .failure(let error):
			print("Error parsing: \(fileResult.fileName)\n\(error.localizedDescription)".red)
		}
	}
}
