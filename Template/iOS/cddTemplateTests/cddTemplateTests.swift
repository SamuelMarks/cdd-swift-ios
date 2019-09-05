//
//  cddTemplateTests.swift
//  cddTemplateTests
//
//  Created by Rob Saunders on 8/25/19.
//  Copyright © 2019 Alexei. All rights reserved.
//

import XCTest
@testable import cddTemplate

class MockClient: APIClientProtocol {
	var jsonData: Data
	var statusCode: Int

	init(json: String, statusCode: Int) {
		self.jsonData = Data(json.utf8)
		self.statusCode = statusCode
	}

	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		let response = HTTPURLResponse(
			url: URL(string: "https://test.local/")!,
			statusCode: self.statusCode,
			httpVersion: nil,
			headerFields: nil)
		completionHandler(self.jsonData, response, nil)
		return URLSessionDataTask()
	}
}

class cddTemplateTests: XCTestCase {

	// GET /pets/{id}
	func testGetPet() {
		let request = PetsPetIdGetRequest(petId: 1)
		let petExpectation = expectation(description: "Expect GET /Pets/{id} to return something")

		request.send(
			client: MockClient(json: #"{"id": 1, "name": "fred"}"#, statusCode: 200),
			onResult: { pet in
				XCTAssertEqual(pet.name, "fred")
				petExpectation.fulfill()
		}, onError: { error in
			XCTFail()
		}, onOtherError: { error in
			XCTFail()
		})

		waitForExpectations(timeout: 1, handler: { result in
			print(result)
		})
	}

}
