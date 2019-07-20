//
//  Model.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation

struct Model: ProjectObject {
	var name: String
	var vars: [Variable]
	var modificationDate: Date
}
