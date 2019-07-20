struct PetsPostRequest : APIRequest {
    typealias ResponseType = EmptyResponse
    typealias ErrorType = APIError
    var urlPath: String { return "/pets" }
    var method: String { return .post }
}
