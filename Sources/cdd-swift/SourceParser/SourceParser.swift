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

func parse(sourceFiles: [SourceFile]) -> ([Model],[Request], [String:URL]) {
    var classToSourceFile: [String:URL] = [:]
    var models: [String:Model] = [:]
    var requests:[String:Request] = [:]
	for sourceFile in sourceFiles {
        let visitor = ClassVisitor()
		sourceFile.syntax.walk(visitor)
        
        for klass in visitor.klasses {
            if klass.interfaces.contains(MODEL_PROTOCOL) {
				models[klass.name] = Model(name: klass.name, vars: Array(klass.vars.values), modificationDate: sourceFile.modificationDate)
                
                classToSourceFile[klass.name] = sourceFile.path
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
                    requests[klass.name] = Request(name:klass.name, method: method, urlPath: path, responseType: responseType, errorType: errorType, vars: Array(vars.values))
                    classToSourceFile[klass.name] = sourceFile.path
                }
            }
        }
        
	}

	

	return (Array(models.values),Array(requests.values), classToSourceFile)
}

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
