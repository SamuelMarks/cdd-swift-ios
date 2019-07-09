//
//  Project.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation

struct Settings {
	let host: URL
}

struct Project {
	var info: ProjectInfo
	var models: [Model]
	var routes: [Route]
}

struct ProjectInfo {
	var hostname: String
}

struct Model {
	let name: String
}

struct Route {
	let paths: [RoutePath]
}

struct RoutePath {
	let requests: [Request]
}

struct Request {
	let method: Method
}

enum Method {
	case get
	case put
}
