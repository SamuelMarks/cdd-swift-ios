import XCTest
@testable import codetester

class codetesterTests: XCTestCase {

	// GET /pets/{id}
	func testGetPet() {
		let request = PetsPetIdGetRequest()

		request.send(
			client: MockClient(json: #"{"id": 1, "name": 1}"#, statusCode: 200),
			onResult: { pet in /*ok*/ },
			onError: { error in XCTFail("onError: \(error)") },
			onOtherError: { error in XCTFail("onOtherError: \(error)") })
	}

	// GET /pets/
	func testGetPets() {
		let request = PetsGetRequest(limit: 1)

		request.send(
			client: MockClient(json: #"[{"id": 1}]"#, statusCode: 200),
			onResult: { pet in /*ok*/ },
			onError: { error in XCTFail("onError: \(error)") },
			onOtherError: { error in XCTFail("onOtherError: \(error)") })
	}
}
