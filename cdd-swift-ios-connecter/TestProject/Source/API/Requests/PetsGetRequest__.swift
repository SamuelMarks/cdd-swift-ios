import Alamofire

struct PetsGetRequest__ : APIRequest {
    typealias ResponseType = [Pet]
    typealias ErrorType = APIError
    var urlPath: String { return "/pets" }
    var method: HTTPMethod { return .get }
    /// How many items to return at one time (max 100)
    let limit: Int?
}
