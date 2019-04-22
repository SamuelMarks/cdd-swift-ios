//
//  ListPets
//  ios-auth-scaffold

import Foundation

class ListPets: ApiBase {
	let baseUrl = "/pets"
	let unrelatedVariable = "ignore me"

	func listPets() -> JSON {
		JsonHttpClient
			.instance(root: baseUrl)
			.post(path: api, data: try? JSONEncoder().encode(auth),
				  completion: { (error: ErrorResponse?, user: User?) in
					if (error != nil) {
						return completion(error, nil)
					} else if (user == nil) {
						return completion(ErrorResponse(error: "NotFound", error_message: "User"), nil)
					}
					Settings.access_token = user!.access_token
					return completion(error, user)
			})
	}
}
