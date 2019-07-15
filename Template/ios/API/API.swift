//
//  API.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import Alamofire
struct Pet : APIModel {
    let tag: String?
    let name: String
    let id: String
}

struct APIError: APIModel {
    let code: Int
    let message: String
}

struct PetsGetRequest : APIRequest {
    typealias ResponseType = [Pet]
    typealias ErrorType = APIError
    var urlPath: String { return "/pets" }
    var method: String { return .get }
    /// How many items to return at one time (max 100)
    let limit: Int?
}

struct PetsPostRequest : APIRequest {
    typealias ResponseType = EmptyResponse
    typealias ErrorType = APIError
    var urlPath: String { return "/pets" }
    var method: String { return .post }
}

struct PetsPetIdGetRequest : APIRequest {
    typealias ResponseType = [Pet]
    typealias ErrorType = APIError
    var urlPath: String { return "/pets/\(petId)" }
    var method: String { return .get }
    /// The id of the pet to retrieve
    let petId: String
}

//
//struct Man : APIModel {
//    let tag: String?
//    let name: String
//    let id: Int
//}
//
//struct MensPostRequest : APIRequest {
//    typealias ResponseType = EmptyResponse
//    typealias ErrorType = APIError
//    var urlPath: String { return "/men" }
//    var method: String { return .post }
//    var men: Man
//}
