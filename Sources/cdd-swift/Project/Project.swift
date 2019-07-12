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
	var modificationDate: Date
	var hostname: URL
}

struct Model {
	let name: String
    let fields: [Field]
}

struct Field {
    let name: String
    let required: Bool
    let type: Type
}

indirect enum Type {
    case primitive(PrimitiveType)
    case array(Type)
    case complex(String)
}

enum PrimitiveType: String {
    case String
    case Int
    case Float
    case Bool
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
