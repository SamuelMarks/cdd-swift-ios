//
//  ProjectReader.swift
//	- Responsible for understanding project directory structure and writing reading files

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
		self.builder.readModel(file: "\(self.path)/ios/API/API.swift")
//        self.builder.readRoute(file: "\(self.path)/Sources/Routes.swift")
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

	func writeProject() {
		// unimplemented
	}
}
