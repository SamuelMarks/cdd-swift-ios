//
//  ProjectReader.swift
//	Responsible for understanding project directory structure and writing reading files
//

import Foundation
import Yams

func readFiles(_ path: String, fileType: String) -> Result<[String], Swift.Error> {
	do {
		let files = try FileManager.default.contentsOfDirectory(at: URL.init(fileURLWithPath: path), includingPropertiesForKeys: [], options:  [.skipsHiddenFiles, .skipsSubdirectoryDescendants])

		return .success(files
			.filter{ $0.pathExtension == fileType }
			.map{ $0.lastPathComponent } as [String])
	}
	catch let error {
		return .failure(error)
	}
}

func readDirectory(_ path: String) -> Result<[String], Swift.Error> {
	do {
		let files = try FileManager.default.contentsOfDirectory(at: URL.init(fileURLWithPath: path), includingPropertiesForKeys: [], options:  [.skipsHiddenFiles, .skipsSubdirectoryDescendants])

		return .success(files.map{ $0.lastPathComponent } as [String])
	}
	catch let error {
		return .failure(error)
	}
}

class ProjectReader {
	let path: String
	var builder: OpenAPIBuilder

	init(path: String) {
		self.path = path
		self.builder = OpenAPIBuilder()
	}

	func readProject() {
		self.builder.readModel(file: "\(self.path)/Sources/Models.swift")
		self.builder.readRoute(file: "\(self.path)/Sources/Routes.swift")
	}

	func writeOpenAPI() -> Result<String, Swift.Error> {
		do {
			let yaml_encoder = YAMLEncoder()
			let encodedYAML = try yaml_encoder.encode(builder.data)
			try encodedYAML.write(toFile: "openapi.yml", atomically: false, encoding: .utf8)

			return .success(encodedYAML)
		}
		catch let error {
			return .failure(error)
		}
	}

	func writeStoryboard() {
		var subviews:[XMLElement] = []

		for models in self.builder.data.components {
			for model in models.value {
				subviews.append(
					inputGroup(title: model.key, fields: (model.value.properties.map({ propertyName, property in
						propertyName
					}))))
			}
		}

		let view = viewElement(key: "view", children: [stackView(height: SCREEN_HEIGHT, children: subviews)])

		do {
			try createStoryboardFrame(content: [view])
				.write(toFile: "Scaffold.storyboard", atomically: false, encoding: .utf8)
			print("wrote Scaffold.storyboard")
		}
		catch {
			print("error writing storyboard file.")
		}
	}

	func writeProject() {
		// unimplemented
	}
}
