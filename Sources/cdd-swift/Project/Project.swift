//
//  Project.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation

enum VariableChange {
    case type(Type)
    case value(String?)
    case optional(Bool)
}

enum Change {
    case insertion(APIObjectChange)
    case deletion(APIObjectChange)
    case update(APIObjectChange)
}

enum APIObjectChange {
    case model(Model,ModelChange?)
    case request(Request,RequestChange?)
}

enum ModelChange {
    case deletion(Variable)
    case insertion(Variable)
    case update(String, [VariableChange])
}

enum RequestChange {
    case deletion(Variable)
    case insertion(Variable)
    case update(String, [VariableChange])
    case responseType(String)
    case errorType(String)
    case path(String)
    case method(Method)
}

struct Settings {
	let host: URL
}

struct Project {
	var info: ProjectInfo
	var models: [Model]
	var requests: [Request]
}

struct ProjectInfo {
	var modificationDate: Date
	var hostname: URL
}

struct Model {
    var name: String
    var vars: [Variable]
    
    func compare(to oldModel:Model) -> [ModelChange] {
        var changes: [ModelChange] = []
        var oldVariables = oldModel.vars
        for variable in self.vars {
            
            if let index = oldVariables.firstIndex(where: {$0.name == variable.name}) {
                let updates = variable.compare(to: oldVariables[index])
                oldVariables.remove(at: index)
                if updates.count > 0 {
                    changes.append(.update(variable.name, updates))
                }
            }
            else {
                changes.append(.insertion(variable))
            }
        }
        
        changes.append(contentsOf:oldVariables.map {.deletion($0)})
        
        return changes
    }
}

struct Variable {
    let name: String
    var optional: Bool
    var type: Type
    var value: String?
    var description: String?
    
    init(name: String) {
        self.name = name
        optional = false
        type = .primitive(.String)
    }
    
    func compare(to oldVariable:Variable) -> [VariableChange] {
        var changes: [VariableChange] = []
        if optional != oldVariable.optional {
            changes.append(.optional(optional))
        }
        if type != oldVariable.type {
            changes.append(.type(type))
        }
        if value != oldVariable.value {
            changes.append(.value(value))
        }
        return changes
    }
}

indirect enum Type: Equatable {
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
    let name: String
	let method: Method
    let urlPath: String
    let responseType: String
    let errorType: String
    let vars: [Variable]
    
    func compare(to oldRequest:Request) -> [RequestChange] {
        var changes: [RequestChange] = []
        var oldVariables = oldRequest.vars
        for variable in self.vars {
            
            if let index = oldVariables.firstIndex(where: {$0.name == variable.name}) {
                let updates = variable.compare(to: oldVariables[index])
                oldVariables.remove(at: index)
                if updates.count > 0 {
                    changes.append(.update(variable.name, updates))
                }
            }
            else {
                changes.append(.insertion(variable))
            }
        }
        
        changes.append(contentsOf:oldVariables.map {.deletion($0)})
        
        if urlPath != oldRequest.urlPath {
            changes.append(.path(urlPath))
        }
        if method != oldRequest.method {
            changes.append(.method(method))
        }
        if responseType != oldRequest.responseType {
            changes.append(.responseType(responseType))
        }
        if errorType != oldRequest.errorType {
            changes.append(.errorType(errorType))
        }
        
        return changes
    }
}

enum Method: String {
	case get
	case put
    case post
}
