import Foundation
import SwiftSyntax

let arguments = Array(CommandLine.arguments.dropFirst())
//let project = try! ProjectReader(path: arguments[0])
let project = try! ProjectReader(path: "/Users/rob/Projects/paid.workspace/cdd/connectors/cdd-swift-ios/Template")

project.readProject()

print(project.project)

//switch project.writeOpenAPI() {
//case .success(let yaml):
//	print("wrote openapi.yml: \(yaml)")
//case .failure(let err):
//	print("error: \(err)")
//}
