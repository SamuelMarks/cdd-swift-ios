//
//  API.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit

//class API {
    struct Person: APIResponse {
        let name: String
        let surname: String
        let people: [Person]
    }


    
    struct GetPersons: APIRequest {
        func path() -> String {
            return "/persons"
        }
        
        typealias ResponseType = [Person]
    }
//}
