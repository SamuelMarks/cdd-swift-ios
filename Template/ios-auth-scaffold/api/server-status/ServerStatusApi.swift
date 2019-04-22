//
//  ServerStatusApi.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 18/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

class ServerStatusApi: ApiBase {
    let api = "/api"

    func get(completion: @escaping (ErrorResponse?, ServerStatus?) -> ()) {
        JsonHttpClient
                .instance(root: baseUrl)
                .get(path: api, completion: completion)
    }
}
