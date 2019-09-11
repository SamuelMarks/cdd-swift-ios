//
//  UnitTestBuilder.swift
//  CDDSwift
//
//  Created by Rob Saunders on 11/09/2019.
//

import Foundation

func buildTestClass(from requests: [Request], projectName: String) -> String {
	let testFunctions =  requests.map({buildTest(from: $0)}).joined(separator: "\n\n")

	return """
	import XCTest
	@testable import \(projectName)

	class cddRequestTests: XCTestCase {

	\(testFunctions)
	
	}
	"""
}

func buildTest(from request: Request) -> String {
	let method = "\(request.method)".uppercased()

	return """
		// \(method) \(request.urlPath)
		fn test\(request.name)() {
			let request = \(request.name)(\(buildParams(request.vars)))

			request.send(
				client: MockClient(json: #"[{"id": 1}]"#, statusCode: 200),
				onResult: { pet in /*ok*/ },
				onError: { error in XCTFail("onError: \\(error)") },
				onOtherError: { error in XCTFail("onOtherError: \\(error)") })
		}
	"""
}

func buildParams(_ vars: [Variable]) -> String  {
	return vars.map({
		"\($0.name): \(defaultArgumentForType($0.type))"
	}).joined(separator: ", ")
}

func defaultArgumentForType(_ type: Type) -> String {
	switch type {
	case .primitive(let t):
		switch t {
		case .Bool:
			return "true"
		case .Float:
			return "0.0"
		case .Int:
			return "1"
		case .String:
			return "\"fred\""
		}
	default:
		return "nil"
	}
}
