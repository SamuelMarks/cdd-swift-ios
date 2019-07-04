//
//  Entity.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

struct APIFieldD {
    var name: String
    var type: String
    
    var isArray: Bool {
        return type.prefix(1) == "["
    }
    var isSimple: Bool {
        return ["string","int","double","bool"].contains(type)
    }
}

struct APIRequestD {
    var path: String
    var method: String
    var fields: [APIFieldD]
    var responseType: String
}

struct APIModelD {
    var name: String
    var fields: [APIFieldD]
}




