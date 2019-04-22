//
//  Loopable.extension.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 19/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation

protocol Loopable {
    var allProperties: [String: Any] { get }
}

extension Loopable {
    var allProperties: [String: Any] {
        var result = [String: Any]()
        Mirror(reflecting: self).children.forEach { child in
            if let property = child.label {
                result[property] = child.value
            }
        }
        return result
    }
}
