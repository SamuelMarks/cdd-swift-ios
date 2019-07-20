struct PetsPetIdGetRequest : APIRequest {
    typealias ResponseType = [Pet]
    typealias ErrorType = APIError
    var urlPath: String { return "/pets/\(petId)" }
    var method: String { return .get }
    /// The id of the pet to retrieve
    let petId: String
}
