//
//  User.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 19/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

struct User: Codable {
    let access_token: String
    let email: String
    let roles: [String]
}
