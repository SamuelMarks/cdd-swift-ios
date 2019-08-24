//
//  Core.swift
//  ios
//
//  Created by Alexei on 16/08/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import Alamofire

private let configuration: URLSessionConfiguration = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 15
    configuration.httpShouldSetCookies = true
    return configuration
}()

private let sessionManager = Alamofire.SessionManager(configuration: configuration)

class Core {
    static var models: [Model] = []
    static var requests: [Request] = []
    
    
    static func sendRequest(request: Request, params: [String:Any], onResult: @escaping (_ result: Any) -> Void,
                            onError: ((_ error: Error) -> Void)? = nil) {
        
        var comps = request.urlPath.components(separatedBy: "/")
        comps = comps.map { component in
            if component.contains("{") {
                let name = component.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
                if let value = params[name] {
                    return "\(value)"
                }
            }
            return component
        }
        
        let newUrl = comps.joined(separator: "/")
        
        let urlRequest = sessionManager.request(HOST + ENDPOINT + newUrl, method: request.method.httpMethod, parameters: params, encoding: URLEncoding.default, headers: headers())
        
        urlRequest.responseString { response in
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
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    onResult(json)
                case .failure(let error):
                    onError?(error)
                    
                }
            })
    }
    static func headers() -> HTTPHeaders {
        return [:]
    }
}


extension Model {
    var restId: String? {
        return vars.first(where: {$0.name == "id" || $0.name == name.lowercased() + "Id"})?.name
    }
}
extension Method{
    var httpMethod: HTTPMethod {
        return HTTPMethod(rawValue: self.rawValue.uppercased()) ?? .get
    }
}


class Alert {
    static func show(error: Error, in vc: UIViewController?) {
        show(text: error.localizedDescription, in: vc)
    }
    
    static func show(text: String, in vc: UIViewController?) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc?.present(alert, animated: true, completion: nil)
    }
}
