struct Testy: APIModel {
    var yep: String
}

struct Gob : APIRequest {
    typealias ResponseType = Booking
    typealias ErrorType = EmptyResponse
    var urlPath: String { return "/api/v2/booking/create" }
    func method() -> HTTPMethod { return .post }
    let tourId: String?
    let scheduleId: String?
}
