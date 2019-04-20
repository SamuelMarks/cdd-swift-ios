import Foundation

struct User {
    let access_token: String
    let email: Int
    let roles: [String]
}

struct Post {
    let title: String
    let body: String
}

public struct Pet: APIModel {
	public var id: Int
	public var name: String
	public var tag: String?
}
