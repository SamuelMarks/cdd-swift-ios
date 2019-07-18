import Foundation
import SwiftSyntax
import SwiftCLI
import Willow

class ColorModifier: LogModifier {
	func modifyMessage(_ message: String, with logLevel: LogLevel) -> String {
		switch logLevel {
		case .error:
			return "[ERROR] \(message)".red
		case .info:
			return "[INFO] \(message)".yellow
		case .event:
			return "[OK] \(message)".green
		default:
			return "[OK] \(message)"
		}
	}
}
let writers = [ConsoleWriter(modifiers: [ColorModifier()])]
let log = Logger(logLevels: [.all], writers: writers)

let cli = CLI(
    name: "cdd-swift",
    version: "0.1.0",
    description: "Compiler Driven Development: Swift Adaptor",
    commands: [
        GenerateCommand(),
        SyncCommand(),
        TestCommand()
    ]
)

cli.goAndExit()
