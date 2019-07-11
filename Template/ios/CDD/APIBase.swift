import Alamofire

let url = "some base url here"

private let configuration: URLSessionConfiguration = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 15
    configuration.httpShouldSetCookies = true
    return configuration
}()
let sessionManager = Alamofire.SessionManager(configuration: configuration)

enum PostTypeCodingError: Error {
    case decoding(String)
}

struct EmptyResponse: Decodable {
    
}

protocol APIModel: Decodable {}

protocol APIRequest: Encodable {
    associatedtype ResponseType: Decodable
    associatedtype ErrorType: Decodable

    func baseURL() -> URL
    func urlPath() -> String
    func method() -> HTTPMethod
    func headers() -> HTTPHeaders
    func isNeedLog() -> Bool
    func isNeedToken() -> Bool
    func send()
    func send(onPaginate: ((_ curPage: Int, _ totalPage: Int) -> Void)?,
              onResult: @escaping (_ result: ResponseType) -> Void,
              onError: @escaping (_ error: ErrorType) -> Void,
              onOtherError: ((_ error: Error) -> Void)?)
}

extension APIRequest {
    static var manager: SessionManager {
        return sessionManager
    }

    func baseURL() -> URL {
        return URL(string: url)!
    }

    func send() {
        send(onResult: { (_) in
            
        }, onError: { (_) in
            
        })
    }

    func headers() -> HTTPHeaders {
        return ["Content-Type": "application/json", "Accept-Language": "RU-ru"]
    }

    func method() -> HTTPMethod {
        return .post
    }

    func isNeedLog() -> Bool {
        return true
    }

    func isNeedToken() -> Bool {
        return true
    }

    func mockFileName() -> String? {
        return nil
    }


    func send(onPaginate: ((_ curPage: Int, _ totalPage: Int) -> Void)? = nil,
                onResult: @escaping (_ result: ResponseType) -> Void,
              onError: @escaping (_ error: ErrorType) -> Void,
              onOtherError: ((_ error: Error) -> Void)? = nil) {

        guard let data = try? JSONEncoder().encode(self),
              let params = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return
        }
        
        sessionManager.startRequestsImmediately = true

        var request: DataRequest?

        request = sessionManager.request(url, method: method(), parameters: params, encoding: JSONEncoding.default, headers: headers())

        request?.responseString { response in
                    guard self.isNeedLog() == true else {
                        return
                    }
                    var logString = ""
                    logString += "\nCURL:"
                    logString += "\n" + (response.request?.cURL ?? "")

                    logString += "\nRESPONSE:"
                    if let value = response.result.value, let code = response.response?.statusCode {

                        logString += "\nCODE: " + String(code)
                        logString += "\n" + value
                    }

                    print(logString)
                }
                .responseData { (response) in

                    switch response.result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let result = try decoder.decode(ResponseType.self, from: data)
                            if let httpResponse = response.response,
                                httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300 {
                                
                                onResult(result)
                            } else {
                            }
                        } catch {
                            do {
                                let result = try decoder.decode(ErrorType.self, from: data)
                                onError(result)
                            }
                            catch {
                                print("📌 📌 📌")
                                print(error)
                                onOtherError?(error)
                            }
                        }
                    case .failure(let error):
                      onOtherError?(error)
                    }
                }
    }
}


public extension URLRequest {

    /// Returns a cURL command for a request
    /// - return A String object that contains cURL command or "" if an URL is not properly initalized.
    public var cURL: String {

        guard
                let url = url,
                let httpMethod = httpMethod,
                url.absoluteString.utf8.count > 0
                else {
            return ""
        }

        var curlCommand = "curl --verbose \\\n"

        // URL
        curlCommand = curlCommand.appendingFormat(" '%@' \\\n", url.absoluteString)

        // Method if different from GET
        if "GET" != httpMethod {
            curlCommand = curlCommand.appendingFormat(" -X %@ \\\n", httpMethod)
        }

        // Headers
        let allHeadersFields = allHTTPHeaderFields!
        let allHeadersKeys = Array(allHeadersFields.keys)
        let sortedHeadersKeys = allHeadersKeys.sorted(by: <)
        for key in sortedHeadersKeys {
            curlCommand = curlCommand.appendingFormat(" -H '%@: %@' \\\n", key, self.value(forHTTPHeaderField: key)!)
        }

        // HTTP body
        if let httpBody = httpBody, httpBody.count > 0 {
            let httpBodyString = String(data: httpBody, encoding: String.Encoding.utf8)!
            let escapedHttpBody = URLRequest.escapeAllSingleQuotes(httpBodyString)
            curlCommand = curlCommand.appendingFormat(" --data '%@' \\\n", escapedHttpBody)
        }

        return curlCommand
    }

    /// Escapes all single quotes for shell from a given string.
    static func escapeAllSingleQuotes(_ value: String) -> String {
        return value.replacingOccurrences(of: "'", with: "'\\''")
    }
}
