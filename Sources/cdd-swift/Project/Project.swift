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
	var models: [String: Model]
	var routes: [String: Route]
}

struct ProjectInfo {
	var hostname: URL
}

struct Model {
	let name: String
}

struct Route {
	let paths: [RoutePath]
}

struct RoutePath {
	let urlPath: String
	let requests: [Request]
}

struct Request {
	let method: Method
}

enum Method {
	case get
	case put
}
