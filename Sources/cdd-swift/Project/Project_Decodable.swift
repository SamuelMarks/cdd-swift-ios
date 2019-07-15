//
//  Project_Decodable.swift
//  cdd-swift
//
//  Created by Alexei on 16/07/2019.
//

import Foundation




//extension APIModelD {
//    func json() -> [String:Any] {
//        return ["name":name,"fields":fields.map {$0.json()},"models":models.map {$0.json()}]
//    }
//    
//    static func fromJson(_ json: [String:Any]) -> APIModelD? {
//        if let name = json["name"] as? String {
//            let fields = (json["fields"] as? [[String:Any]]) ?? []
//            let models = (json["models"] as? [[String:Any]]) ?? []
//            var model = APIModelD(name: name, fields: fields.compactMap {APIFieldD.fromJson($0)})
//            model.models = models.compactMap {APIModelD.fromJson($0)}
//            return model
//        }
//        return nil
//    }
//}
//
//extension APIRequestD {
//    func json() -> [String:Any] {
//        return ["path":path,"method":method,"fields":fields.map {$0.json()}]
//    }
//    
//    static func fromJson(_ json: [String:Any]) -> APIRequestD? {
//        if let path = json["path"] as? String,
//            let method = json["method"] as? String {
//            let fields = (json["fields"] as? [[String:Any]]) ?? []
//            let request = APIRequestD(path: path, method: method, fields: fields.compactMap {APIFieldD.fromJson($0)}, responseType: "", errorType: "", description: nil)
//            return request
//        }
//        return nil
//    }
//}
