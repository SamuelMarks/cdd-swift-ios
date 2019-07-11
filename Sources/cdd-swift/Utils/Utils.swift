//
//  Utils.swift
//  CYaml
//
//  Created by Rob Saunders on 7/10/19.
//

import Foundation

/// read files in a directory to [URL]
func readDirectory(_ path: String) -> Result<[URL], Swift.Error> {
	do {
		let files = try FileManager.default.contentsOfDirectory(at: URL.init(fileURLWithPath: path), includingPropertiesForKeys: [], options:  [.skipsHiddenFiles, .skipsSubdirectoryDescendants])

		return .success(files.map{ URL(fileURLWithPath: $0.lastPathComponent) })
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

extension String {
    var trimmedWhiteSpaces: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
