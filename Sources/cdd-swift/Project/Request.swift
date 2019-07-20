//
//  Request.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation
struct Request: ProjectObject {
	let name: String
	let method: Method
	let urlPath: String
	let responseType: String
	let errorType: String
	let vars: [Variable]
    var modificationDate: Date
}

enum Method: String {
	case get
	case put
	case post
}
