import Foundation
import SwiftSyntax

let arguments = Array(CommandLine.arguments.dropFirst())
let project = ProjectReader(path: arguments[0])

project.readProject()

//switch project.writeOpenAPI() {
//case .success(let yaml):
//	print("wrote openapi.yml: \(yaml)")
//case .failure(let err):
//	print("error: \(err)")
//}
