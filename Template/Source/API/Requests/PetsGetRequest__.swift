struct PetsGetRequest___ : APIRequest {
    typealias ResponseType = [Pet]
    typealias ErrorType = APIError
    var urlPath: String { return "/pets" }
    var method: String { return .get }
    /// How many items to return at one time (max 100)
    let limit: Int?
}
