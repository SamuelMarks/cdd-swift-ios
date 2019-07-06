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

func readOpenApi(_ path: String) throws -> SwaggerSpec {
	// note: should look for json first, in default location. CHANGEME
	let url = URL(fileURLWithPath: path + "/Examples/petstore.yml")

	let data: Data
	do {
		data = try Data(contentsOf: url)
	} catch {
		throw SwaggerError.loadError(url)
	}

	if let string = String(data: data, encoding: .utf8) {
		return try SwaggerSpec.init(string: string)
	} else if let string = String(data: data, encoding: .ascii) {
		return try SwaggerSpec.init(string: string)
	} else {
		throw SwaggerError.parseError("Swagger doc is not utf8 or ascii encoded")
	}
}

class ProjectReader {
	let openapi: SwaggerSpec

	let path: String
//	var builder: OpenAPIBuilder

	init(path: String) throws {
		self.path = path
//		self.builder = OpenAPIBuilder()



		self.openapi = try readOpenApi(path)
	}

	func readProject() {
//		self.builder.readModel(file: "\(self.path)/ios/API/API.swift")
//        self.builder.readRoute(file: "\(self.path)/Sources/Routes.swift")
	}

//	func writeOpenAPI() -> Result<String, Swift.Error> {
//		do {
//			let yaml_encoder = YAMLEncoder()
//			let encodedYAML = try yaml_encoder.encode(builder.data)
//			try encodedYAML.write(toFile: "openapi.yml", atomically: false, encoding: .utf8)
//
//			return .success(encodedYAML)
//		}
//		catch let error {
//			return .failure(error)
//		}
//	}

	func writeProject() {
		// unimplemented
	}
}
