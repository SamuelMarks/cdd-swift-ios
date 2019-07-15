//
//  StdOut.swift
//  CYaml
//
//  Created by Rob Saunders on 7/15/19.
//

import Foundation
import Rainbow

func printChangeResult(_ result: ChangeResult) {
	switch result {
	case .success(let msg):
		print("[OK] \(msg)".green)
	case .failure(let msg):
		print("[Error] \(msg)".red)
	}
}

func printResult<T>(fileName: String, result: Result<T, Swift.Error>) {
	switch result {
	case .success(_):
		print("[OK] Parsed \(fileName)".green)
	case .failure(let error):
		print("[Error] parsing: \(fileName):\n\(error.localizedDescription)".red)
	}
}

func printFileResults<T>(fileResults: [FileResult<T>]) {
	for fileResult in fileResults {
		printResult(fileName: fileResult.fileName, result: fileResult.result)
	}
}

func printSuccess(_ string: String) {
	print("[OK] \(string)".green)
}

func exitWithError(_ string: String) -> Never {
	print("[Error] \(string)".red)
	exit(EXIT_FAILURE)
}

func exitWithError(_ error: Swift.Error) -> Never {
	print("[Error] \(error)".red)
	exit(EXIT_FAILURE)
}

// todo: not printing localisedDescription correctly
func printError(_ error: Swift.Error) {
	print("[Error] \(error)".red)
}
