//
//  Utils.swift
//  CYaml
//
//  Created by Rob Saunders on 7/10/19.
//

import Foundation

func writeStringToFile(file: URL, contents: String) -> Result<(), Swift.Error> {
	if config.dryRun == true {
		return .success(())
	}

	do {
		try contents.write(toFile: file.path, atomically: false, encoding: String.Encoding.utf8)
		return .success(())
	}
	catch let err { return .failure(err) }
}

/// read files in a directory to [URL]
func readDirectory(_ path: String) -> Result<[URL], Swift.Error> {
	do {
		let files = try FileManager.default.contentsOfDirectory(at: URL.init(fileURLWithPath: path), includingPropertiesForKeys: [], options:  [.skipsHiddenFiles, .skipsSubdirectoryDescendants])

		return .success(files)
	}
	catch let error {
		return .failure(error)
	}
}

/// read file contents to string
func readFile(_ url: URL) -> Result<String, Swift.Error> {
	do {
		let file = try String(contentsOf: url, encoding: .utf8)
		return .success(file)
	}
	catch let error {
		return .failure(error)
	}
}

/// trim unnecessary characters from a string
func trim(_ string: String) -> String {
	return string
		.trimmingCharacters(in: .whitespacesAndNewlines)
		.replacingOccurrences(of: "\"", with: "")
}

func fileLastModifiedDate(file: String) -> Date? {
	do {
		let attributes = try FileManager.default.attributesOfItem(atPath: file)
		return attributes[FileAttributeKey.modificationDate] as? Date
	}
	catch let error as NSError {
		print("Ooops! Something went wrong: \(error)")
		return nil
	}
}

func fileLastModifiedDate(url: URL) throws -> Date {
	do {
		let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
		return attributes[FileAttributeKey.modificationDate] as! Date
	}
	catch {
		throw ProjectError.InvalidSettingsFile("could not determine modified date for file: \(url.path)")
	}
}

extension String {
    var trimmedWhiteSpaces: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

func fileExists(file: String) -> Bool {
	return FileManager.default.fileExists(atPath: file)
}
