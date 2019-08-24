//
//  LoginPostRequest.swift
//  ios
//
//  Created by Alexei on 14/08/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//
import Alamofire

struct RegisterPostRequest : APIRequest {
    typealias ResponseType = User
    typealias ErrorType = EmptyResponse
    var urlPath: String { return "/api/v2/register"}
    var method: HTTPMethod { return .post }
    let phone: String
}
