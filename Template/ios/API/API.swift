//
//  API.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import Alamofire

struct APIError: Decodable {
    let code: Int
    let message: String
}

struct Pet : Decodable {
    let tag: String?
    let name: String
    let id: Int
}

struct PetsGetRequest : APIRequest {
    typealias ResponseType = [Pet]
    typealias ErrorType = APIError
    func path() -> String { return "/pets" }
    func method() -> HTTPMethod { return .get }
    let limit: Int?
}

struct PetsPostRequest : APIRequest {
    typealias ResponseType = EmptyResponse
    typealias ErrorType = APIError
    func path() -> String { return "/pets" }
    func method() -> HTTPMethod { return .post }
}

struct PetsPetIdGetRequest : APIRequest {
    typealias ResponseType = [Pet]
    typealias ErrorType = APIError
    func path() -> String { return "/pets/\(petId)" }
    func method() -> HTTPMethod { return .get }
    let petId: String
}

