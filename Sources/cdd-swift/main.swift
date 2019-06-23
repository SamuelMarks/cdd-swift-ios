import Foundation
import SwiftSyntax

let arguments = Array(CommandLine.arguments.dropFirst())
//let filePath = URL(fileURLWithPath: arguments[0])

//let builder = OpenAPIBuilder()

//let sb = StoryboardWriter()
//print(createDefaultStoryboard())

let project = ProjectReader(path: "/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Examples/Basic/"
)

project.readProject()

switch project.writeOpenAPI() {
case .success(let yaml):
	print("wrote openapi.yml")
case .failure(let err):
	print("error: \(err)")
}

project.writeStoryboard()

//let yamlPath = filePath.deletingPathExtension().appendingPathExtension("yaml")
//try! fileSystem.writeFileContents(AbsolutePath(yamlPath.path), bytes: ByteString(encodingAsUTF8: encodedYAML))
