import Foundation
import Basic
import SwiftSyntax
import Yams

let arguments = Array(CommandLine.arguments.dropFirst())
let filePath = URL(fileURLWithPath: arguments[0])

let sourceFile = try! SyntaxTreeParser.parse(filePath)
let visitor = TokenVisitor()
sourceFile.walk(visitor)
let html = "\(visitor.list.joined())"

let tree = visitor.tree
let encoder = JSONEncoder()
let json = String(data: try! encoder.encode(tree), encoding: .utf8)!

let fileSystem = Basic.localFileSystem

let htmlPath = filePath.deletingPathExtension().appendingPathExtension("html")
try! fileSystem.writeFileContents(AbsolutePath(htmlPath.path), bytes: ByteString(encodingAsUTF8: html))

let jsonPath = filePath.deletingPathExtension().appendingPathExtension("json")
try! fileSystem.writeFileContents(AbsolutePath(jsonPath.path), bytes: ByteString(encodingAsUTF8: json))

let yaml_encoder = YAMLEncoder()
let encodedYAML = try yaml_encoder.encode(tree)

let yamlPath = filePath.deletingPathExtension().appendingPathExtension("yaml")
try! fileSystem.writeFileContents(AbsolutePath(yamlPath.path), bytes: ByteString(encodingAsUTF8: encodedYAML))
