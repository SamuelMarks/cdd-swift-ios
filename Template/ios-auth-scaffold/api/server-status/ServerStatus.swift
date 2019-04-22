//
//  ServerStatus.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 18/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

struct ServerStatus: Codable {
    let version: String
    let private_ip: String

    func getString() -> String {
        return "\(version) @ \(private_ip)"
    }
}
