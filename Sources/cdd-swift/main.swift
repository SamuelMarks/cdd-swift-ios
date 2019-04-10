import Foundation
import Basic
import SwiftSyntax
import Yams
// import SwagGenKit
// import Swagger

let arguments = Array(CommandLine.arguments.dropFirst())

let filePath = URL(fileURLWithPath: "/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Examples/Petstore/Sources/Models/Models.swift")
//let filePath = URL(fileURLWithPath: arguments[0])

let sourceFile = try! SyntaxTreeParser.parse(filePath)
let visitor = TokenVisitor()
sourceFile.walk(visitor)

let fileSystem = Basic.localFileSystem

let yaml_encoder = YAMLEncoder()
let encodedYAML = try yaml_encoder.encode(visitor.api)

let yamlPath = filePath.deletingPathExtension().appendingPathExtension("yaml")
try! fileSystem.writeFileContents(AbsolutePath(yamlPath.path), bytes: ByteString(encodingAsUTF8: encodedYAML))

print(encodedYAML)
