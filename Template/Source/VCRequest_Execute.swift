//
//  VCRequest_Execute.swift
//  ios
//
//  Created by Alexei on 14/08/2019.
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

extension Method{
    var httpMethod: HTTPMethod {
        return HTTPMethod(rawValue: self.rawValue.uppercased()) ?? .get
    }
}
extension VCRequest {
    
    func execute(onResult: @escaping (_ result: Any) -> Void,
                 onError: ((_ error: Error) -> Void)? = nil) {
        
        let params: [String:Any] = request.vars.reduce(into: [:]) { (res, variable) in
            guard let stackView = varsToStackView[variable.name],
            let value = extractVarValue(type: variable.type, stackView: stackView) else { return }
            res[variable.name] = value
        }
        
        let urlRequest = sessionManager.request(HOST + ENDPOINT + request.urlPath, method: request.method.httpMethod, parameters: params, encoding: URLEncoding.default, headers: headers())
        
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
    
    func extractVarValue(type:Type, stackView: UIStackView) -> Any? {
        
        let extractTFData: (PrimitiveType,String)-> Any? = {
            switch $0 {
            case .Bool:
                return $1 == "True"
            case .Float:
                return Float($1)
            case .Int:
                return Int($1)
            case .String:
                return $1
            }
        }
        
        switch type {
        case .primitive(let type):
            if let tf = stackView.arrangedSubviews.first(where: {$0 is UITextField}) as? UITextField, let text = tf.text, text.count > 0 {
                return extractTFData(type,text)
            }
        case .array(let type):
            if case .primitive(let type) = type {
                var res: [Any] = []
                stackView.arrangedSubviews.forEach {
                    if let tf = $0 as? UITextField,let text = tf.text, text.count > 0, let value = extractTFData(type,text) {
                        res.append(value)
                    }
                }
                return res
            }
        case .complex: break
        }
        
        return nil
    }
    
    func headers() -> HTTPHeaders {
        return [:]
    }
    
}
