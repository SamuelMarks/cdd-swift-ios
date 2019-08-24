//
//  StdOut.swift
//  CYaml
//
//  Created by Rob Saunders on 7/15/19.
//

import Foundation
import Rainbow

func exitWithError(_ string: String) -> Never {
	print("[Error] \(string)".red)
	exit(EXIT_FAILURE)
}

func exitWithError(_ error: Swift.Error) -> Never {
	print("[Error] \(error)".red)
	exit(EXIT_FAILURE)
}
