import Foundation

struct User: Codable {
    let access_token: String
    let email: String
    let roles: [String]
}
