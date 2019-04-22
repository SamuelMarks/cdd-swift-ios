//
//  AuthApi.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 18/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

class AuthApi: ApiBase {
    let api = "/api/auth";

    func register(auth: Auth, completion: @escaping (ErrorResponse?, User?) -> ()) {
        JsonHttpClient
                .instance(root: baseUrl)
                .post(path: api, data: try? JSONEncoder().encode(auth),
                        completion: { (error: ErrorResponse?, user: User?) in
                            if (error != nil) {
                                return completion(error, nil)
                            } else if (user == nil) {
                                return completion(ErrorResponse(error: "NotFound", error_message: "User"), nil)
                            }
                            Settings.access_token = user!.access_token
                            return completion(error, user)
                        })
    }
}
