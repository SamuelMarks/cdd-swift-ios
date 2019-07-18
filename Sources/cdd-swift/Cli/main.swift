import Foundation
import SwiftSyntax
import SwiftCLI
import Willow

let defaultLogger = Logger(logLevels: [.all], writers: [ConsoleWriter()])

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
