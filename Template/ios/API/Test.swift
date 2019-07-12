//struct Testy: APIModel {
//    var someString:    String
//    var someInt: Int
//    var someArray: [Testy]
//    var flo: Float = 0
//    var hidenString =    "fssfs"
//    var hidInt = 433
//    var hidBool = true
//    var hidFloat = 4.44
//}

struct Gob : APIRequest {
    typealias ResponseType = Booking
    typealias ErrorType = EmptyResponse
    
    var urlPath: String {     return     "/api/v2/booking/create/\(tourId)" }
    var method: HTTPMethod {     return    .post }
    let tourId: String?
    let scheduleId: String?
}

