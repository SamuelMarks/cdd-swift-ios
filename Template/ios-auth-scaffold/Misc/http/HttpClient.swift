//
//  HttpClient.swift
//  ios-auth-scaffold
//
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

// See RFC7231 and RFC5789 for more info
enum HttpMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case patch = "PATCH"
}

class HttpClient {
    let root: String

    /*
    static var _httpClient: HttpClient!
    static func instance(root: String?) -> HttpClient {
        if (_httpClient == nil) {
            _httpClient = HttpClient(root: root)
        }
        return _httpClient
    }
    */

    init(root path: String?) {
        if let path = path {
            self.root = path
        } else {
            self.root = ""
        }
    }

    convenience init() {
        self.init(root: nil)
    }

    final func toApiPath(_ path: String) -> String {
        return path.starts(with: "http") ? path : "\(root)\(path.starts(with: "/") ? path : "/" + path)"
    }

    func request<T: Decodable>(url: URL, mimeType: String, method: HttpMethod,
                               data: Data?, completion: @escaping (ErrorResponse?, T?) -> ()) {
        var request = URLRequest(url: url)
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        if Settings.access_token != nil {
            request.setValue(Settings.access_token, forHTTPHeaderField: "X-Access-Token")
        }
        request.httpMethod = method.rawValue
        if data != nil && method != .get {
            request.httpBody = data!
            print("request.httpMethod", request.httpMethod!, url.absoluteURL, request.httpBody!,
                    String(describing: String(data: request.httpBody!, encoding: String.Encoding.utf8)))
        }

        let session = URLSession.shared

        let er = "error calling \(request.httpMethod!) on \(url.absoluteURL)"

        let task: URLSessionDataTask = session.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                return completion(ErrorResponse(error: "dataTask", error_message: "\(er)\n\(error!)"), nil)
            }
            guard let responseData = data else {
                return completion(
                        ErrorResponse(error: "responseData", error_message: "\(er)\nError: did not receive data"), nil)
            }

            do {
                let j = try JSONDecoder().decode(T.self, from: responseData);
                return completion(nil, j)
            } catch {
                do {
                    var e: ErrorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                    e._meta = er
                    return completion(e, nil)
                } catch {

                    do {
                        var e: ErrorResponse = try JSONDecoder()
                                .decode(ErrorCodeResponse.self, from: responseData)
                                .toErrorResponse()
                        e._meta = er
                        return completion(e, nil)
                    } catch {

                        // do {

                        return completion(ErrorResponse(error: "JSONDecoder",
                                error_message: "failed on \(request.httpMethod!) \(url.absoluteURL)." +
                                        " Str: \(String(describing: String(data: responseData, encoding: String.Encoding.utf8)!))"), nil)
                        /*} catch {
                            return completion(ErrorResponse(error: "JSONDecoder",
                                    error_message: "failed on \(request.httpMethod!) \(url.absoluteURL). Raw: \(responseData)"),
                                    nil)
                        }*/
                    }
                }
            }
        }
        task.resume()
    }
}
