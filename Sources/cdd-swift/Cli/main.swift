import Foundation
import SwiftSyntax
import SwiftCLI
import Willow

class Config {
	var dryRun: Bool = false
}

let config = Config()

let cli = CLI(
    name: "cdd-swift",
    version: "0.1.0",
    description: "Compiler Driven Development: Swift Adaptor",
    commands: [
        GenerateCommand(),
        SyncCommand()
    ]
)

cli.goAndExit()
