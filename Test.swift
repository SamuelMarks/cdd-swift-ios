struct Testy: APIModel {
    var someString:    String
    var someInt: Int
    var someArray: [Testy]
    var sdfs: Float = 0
    var hidenString =    "fssfs"
    var hidInt = 433
    var hidBool = true
}

struct Gob : APIRequest {
    typealias ResponseType = Booking
    typealias ErrorType = EmptyResponse
    var urlPath: String { return "/api/v2/booking/create" }
    func method() -> HTTPMethod { return .post }
    let tourId: String?
    let scheduleId: String?
}

