import Foundation

class AuthApi: ApiBase {
	let baseUrl = "/api/auth";

	func register(auth: Auth, completion: @escaping (ErrorResponse?, User?) -> ()) {
		let subtest: String = "ignoreme"
		
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
