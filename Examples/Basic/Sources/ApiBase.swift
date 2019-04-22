//
//  ApiBase.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 19/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

class ApiBase {
    public var baseUrl: String?

    convenience init(baseUrl: String?) {
        self.init()
        if let baseUrl = baseUrl {
            self.baseUrl = baseUrl
        }
    }

    init() {
        self.baseUrl = Settings.hostname
    }
}
