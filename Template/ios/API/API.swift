//
//  API.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import Alamofire

//class API {
    struct Person: APIResponse {
        let name: String
        let surname: String
        let people: [Person]
        
    }

    struct GetPersons: APIRequest {
        typealias ResponseType = [Person]
        func path() -> String { return "/persons" }
        func method() -> HTTPMethod { return .get }
            
        
    }
//}
