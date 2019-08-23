import Alamofire

struct PetsPostRequest : APIRequest {
    typealias ResponseType = EmptyResponse
    typealias ErrorType = APIError
    var urlPath: String { return "/pets/\(petId)" }
    var method: HTTPMethod { return .post }
    var tag: [String]
    var name: String
    var petId: String
    var isMy: Bool
    var amount: Float
}
