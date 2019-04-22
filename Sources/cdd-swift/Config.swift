//
//  Config.swift
//  Basic
//
//  Created by Rob Saunders on 11/04/2019.
//

import Foundation
import Yams

public struct Config {

}

public func load() -> Config {
	let decoder = YAMLDecoder()
	let config = Config()

	return config
}
