import Foundation
import Basic
import SwiftSyntax
import Yams

let arguments = Array(CommandLine.arguments.dropFirst())
//let filePath = URL(fileURLWithPath: arguments[0])

let builder = OpenAPIBuilder()
let yaml_encoder = YAMLEncoder()
let encodedYAML = try yaml_encoder.encode(builder.data)
print(encodedYAML)

//let yamlPath = filePath.deletingPathExtension().appendingPathExtension("yaml")
//try! fileSystem.writeFileContents(AbsolutePath(yamlPath.path), bytes: ByteString(encodingAsUTF8: encodedYAML))
