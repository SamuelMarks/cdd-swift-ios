import XCTest
@testable import codetester

class codetesterTests: XCTestCase {

// GET /pets/{id}
func testGetPet() {
let request = PetsPetIdGetRequest()
let petExpectation = expectation(description: "Expect GET /pets/{id} to return something")

request.send(
client: MockClient(json: #"{"id": 1, "name": 1}"#, statusCode: 200),
onResult: { pet in petExpectation.fulfill() },
onError: { error in XCTFail("onError: \(error)") },
onOtherError: { error in XCTFail("onOtherError: \(error)") })

waitForExpectations(timeout: 1, handler: { result in
})
}
}
