//
//  JsonHttpClient.swift
//  ios-auth-scaffold
//
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

class JsonHttpClient: HttpClient {
    static var _jsonHttpClient: JsonHttpClient!

    static func instance(root: String?) -> JsonHttpClient {
        if (_jsonHttpClient == nil || _jsonHttpClient.root != root) {
            _jsonHttpClient = JsonHttpClient(root: root)
        }
        return _jsonHttpClient
    }

    static func instance() -> JsonHttpClient {
        if (_jsonHttpClient == nil || _jsonHttpClient.root != "") {
            _jsonHttpClient = JsonHttpClient()
        }
        return _jsonHttpClient
    }

    func get<T: Decodable>(path: String, completion: @escaping (ErrorResponse?, T?) -> ()) {
        guard let url = URL(string: toApiPath(path)) else {
            return completion(ErrorResponse(error: "URL", error_message: "Cannot create URL from \(path)"), nil)
        }

        request(url: url, mimeType: mimeTypes["json"]!, method: .get, data: nil, completion: completion)
    }

    func post<T: Decodable>(path: String, data: Data?, completion: @escaping (ErrorResponse?, T?) -> ()) {
        guard let url = URL(string: toApiPath(path)) else {
            return completion(ErrorResponse(error: "URL", error_message: "Cannot create URL from \(path)"), nil)
        }

        request(url: url, mimeType: mimeTypes["json"]!, method: .post, data: data, completion: completion)
    }

    func put<T: Decodable>(path: String, data: Data?, completion: @escaping (ErrorResponse?, T?) -> ()) {
        guard let url = URL(string: toApiPath(path)) else {
            return completion(ErrorResponse(error: "URL", error_message: "Cannot create URL from \(path)"), nil)
        }

        request(url: url, mimeType: mimeTypes["json"]!, method: .put, data: data, completion: completion)
    }

    func delete<T: Decodable>(path: String, data: Data?, completion: @escaping (ErrorResponse?, T?) -> ()) {
        guard let url = URL(string: toApiPath(path)) else {
            return completion(ErrorResponse(error: "URL", error_message: "Cannot create URL from \(path)"), nil)
        }

        request(url: url, mimeType: mimeTypes["json"]!, method: .delete, data: data, completion: completion)
    }
}
