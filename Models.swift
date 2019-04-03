import Foundation

struct User: Codable {
    let access_token: String
    let email: String
    let roles: [String]
}

struct Post: Codable {
    let title: String
    let body: String
}
