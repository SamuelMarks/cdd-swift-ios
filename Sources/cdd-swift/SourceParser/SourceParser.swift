//
//  SourceParser.swift
//  Basic
//
//  Created by Rob Saunders on 7/6/19.
//

import Foundation
import SwiftSyntax

let MODEL_PROTOCOL = "APIModel"
let REQUEST_PROTOCOL = "APIRequest"

func parseModels(sourceFiles: [SourceFile]) -> [String: Model] {
	let visitor = ClassVisitor()
	var models: [String: Model] = [:]
    var requests:[Request] = []
	for sourceFile in sourceFiles {
		sourceFile.syntax.walk(visitor)
	}

	for klass in visitor.klasses {
		if klass.interfaces.contains(MODEL_PROTOCOL) {
			models[klass.name] = Model(name: klass.name, vars: Array(klass.vars.values))
		}
	}
    
    for klass in visitor.klasses {
        if klass.interfaces.contains(REQUEST_PROTOCOL) {
            if let responseType = klass.typeAliases["ResponseType"],
                let errorType = klass.typeAliases["ErrorType"],
            let path = klass.vars["urlPath"]?.value,
            let methodRaw = klass.vars["method"]?.value,
                let method = Method(rawValue:methodRaw){
                var vars = klass.vars
                vars.removeValue(forKey: "urlPath")
                vars.removeValue(forKey: "method")
                requests.append(Request(method: method, urlPath: path, responseType: responseType, errorType: errorType, vars: Array(vars.values)))
            }
        }
    }
    
    print(requests)

	return models
}

func parseRequests(sourceFiles: [SourceFile]) -> [Request] {
    
    
//    [Request] - > [path: [Request]]
    
    let requests: [Request] = []
    var res: [String:[Request]] = [:]
    
    for request in requests {
        if var arr = res[request.urlPath] {
            arr.append(request)
        }
        else {
            res[request.urlPath] = [request]
        }
    }
    
//    let visitor = ClassVisitor()
//    var models: [String: Model] = [:]
//
//    for sourceFile in sourceFiles {
//        sourceFile.syntax.walk(visitor)
//    }
//
//    for klass in visitor.klasses {
//        if klass.interfaces.contains(MODEL_PROTOCOL) {
//            models[klass.name] = Model(name: klass.name, vars: Array(klass.vars.values))
//        }
//    }
//
//    return models
    return []
}



//func parseRoutes(sourceFiles: [SourceFile]) -> [String: Route] {
//    let visitor = ClassVisitor()
//    var routes: [String: Route] = [:]
//
//    for sourceFile in sourceFiles {
//        sourceFile.syntax.walk(visitor)
//    }
//
//    for klass in visitor.klasses {
//        if klass.interfaces.contains(ROUTE_PROTOCOL) {
//            if let e = klass.vars["urlPath"]?.type,
//                case let .complex(url) = e {
//                let paths = Route(paths: [RoutePath(urlPath: url, requests: [])])
//                routes[klass.name] = paths
//            }
//        }
//    }
//
//    // todo: complete
//    return routes
//}

func parseProjectInfo(_ source: SourceFile) -> Result<ProjectInfo, Swift.Error> {
	let visitor = ExtractVariables()
	source.syntax.walk(visitor)

	guard let hostname = visitor.variables["HOST"], let endpoint = visitor.variables["ENDPOINT"] else {
		return .failure(
			ProjectError.InvalidSettingsFile("Cannot find HOST or ENDPOINT variables in Settings.swift"))
	}

    guard let hosturl = URL(string: (hostname.value ?? "") + (endpoint.value ?? "")) else {
		return .failure(
			ProjectError.InvalidHostname("Invalid hostname format: \(hostname), \(endpoint)"))
	}

	return .success(ProjectInfo(modificationDate: source.modificationDate, hostname: hosturl))
}
