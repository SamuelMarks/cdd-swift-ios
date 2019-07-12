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
	var routes: [Request]
}

struct ProjectInfo {
	var modificationDate: Date
	var hostname: URL
}

struct Model {
	let name: String
    let vars: [Variable]
}

struct Variable {
    let name: String
    var optional: Bool
    var type: Type
    var value: String?
    
    init(name: String) {
        self.name = name
        optional = false
        type = .primitive(.String)
    }
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

struct Request {
	let method: Method
    let urlPath: String
    let responseType: String
    let errorType: String
    let vars: [Variable]
}

enum Method: String {
	case get
	case put
    case post
}
