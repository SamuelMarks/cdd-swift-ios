//
//  Entity.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import Foundation

struct APIFieldD {
    var name: String
    var type: String
    var cases: [String] = []
    var isEnum: Bool {
        return cases.count > 0
    }
    init(name: String,type: String) {
        let cleanType = type.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "?", with: "")
        var newType = ""
        if cleanType == "integer" || cleanType == "number" {
            newType = "Int"
        }
        else if cleanType == "boolean" {
            newType = "Bool"
        }
        else {
            newType = cleanType.capitalizingFirstLetter()
        }
        self.type = type.replacingOccurrences(of: cleanType, with: newType)
        self.name = name
    }
    
    var clearType: String {
        return type.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "?", with: "")
    }

    var isArray: Bool {
        return type.prefix(1) == "["
    }
    var isSimple: Bool {
        return ["String","Int","Double","Bool"].contains(type)
    }
}

struct APIRequestD {
    var path: String
    var method: String
    var fields: [APIFieldD]
    var responseType: String
    var errorType: String
}

struct APIModelD {
    var models: [APIModelD] = []
    var name: String
    var fields: [APIFieldD]
    var shouldBeUsedAsArray = false
    
    init(name:String,fields:[APIFieldD]) {
        self.name = name.capitalizingFirstLetter()
        self.fields = fields
    }
}
