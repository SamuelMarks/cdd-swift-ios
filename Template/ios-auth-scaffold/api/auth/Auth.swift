//
//  Auth.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 19/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

struct Auth: Codable {
    let email: String
    let password: String

    /*func getString() -> String {
        return "\"email\": \"\(email)\", \"password\":\"\(password)\""
    }*/

    func toJSON() -> Data? {
        return try? JSONSerialization.data(
                withJSONObject: self, options: []
        )
    }
}
