//
//  ErrorCodeResponse.swift
//  ios-auth-scaffold
//
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

struct ErrorCodeResponse: Codable {
    let code: String
    let message: String

    func toErrorResponse() -> ErrorResponse {
        let _code = "\(code): "
        return ErrorResponse(error: code,
                error_message: message.starts(with: _code) ?
                        String(message.suffix(from: message.index(message.startIndex, offsetBy: _code.count)))
                        : message)
    }
}

