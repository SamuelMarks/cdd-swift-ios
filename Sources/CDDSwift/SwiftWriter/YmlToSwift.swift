//
//  YmlToSwift.swift
//  cdd-swift
//
//  Created by Alexei on 08/07/2019.
//
import Foundation
//import PathKit
import Yams
import JSONUtilities

class YmlToSwift {
    
    static let testUrl = URL(fileURLWithPath: "/Users/alexei/Documents/Projects/cdd-swift-ios/Examples/swagger.yaml")
    static let testUrlForSwift = URL(fileURLWithPath: "/Users/alexei/Documents/Projects/cdd-swift-ios/Examples/REST.swift")
    
    static let testUrlForTestObjects = URL(fileURLWithPath: "/Users/alexei/Documents/Projects/cdd-swift-ios/Examples/TestObjects.string")
    
    
    func getSpec(url: URL) throws -> SwaggerSpec {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw SwaggerError.loadError(url)
        }
        
        if let string = String(data: data, encoding: .utf8) {
            return try SwaggerSpec.init(string: string)
        } else if let string = String(data: data, encoding: .ascii) {
            return try SwaggerSpec.init(string: string)
        } else {
            throw SwaggerError.parseError("Swagger doc is not utf8 or ascii encoded")
        }
    }
    
    func parseType(_ json: [String:Any], couldBeObjectName: String = "") -> (String,APIModelD?) {
        if let type = json["type"] as? String {
            if type == "array", let items = json["items"] as? [String:Any] {
                let res = parseType(items,couldBeObjectName: couldBeObjectName)
                return ("[" + res.0 + "]", res.1)
            }
            else
                if type == "object" {
                    if let model = parseObject(name: couldBeObjectName, json: json) {
                        return (couldBeObjectName, model)
                    }
                }
                else {
                    return (type,nil)
            }
        }
        return ("",nil)
    }
    
    func parseObject(name: String, json: [String:Any]) -> APIModelD? {
        guard let properties = json["properties"] as? [String:[String:Any]] else { return nil }
        let required = (json["required"] as? [String]) ?? []
        var fields: [APIFieldD] = []
        var additionalModels: [APIModelD] = []
        for property in properties {
            let result = parseType(property.value, couldBeObjectName: property.key)
            if let model = result.1 {
                additionalModels.append(model)
            }
            var field = APIFieldD(name: property.key, type: result.0 + (required.contains(property.key) ? "" : "?"))
            field.description = property.value["description"] as? String
            if field.clearType.count > 0 {
                fields.append(field)
            }
        }
        var model = APIModelD(name: name, fields: fields)
        model.models = additionalModels
        return model
    }
    
    func run(urlToSpec: URL, urlForSwiftFile: URL) throws {
        let bookedWords = ["Error","Class"]
        let spec:SwaggerSpec = try getSpec(url: urlToSpec)
        
        var arrayTypes: [(name:String,type:String)] = []
        var models:[APIModelD] = []
        var enums: [APIFieldD] = []
        for schema in spec.components.schemas {
            if let dataType = schema.value.metadata.type {
                switch dataType {
                case .object:
                    if let model = parseObject(name: schema.name, json: schema.value.metadata.json) {
                        models.append(model)
                    }
                case .array:
                    if let items = schema.value.metadata.json["items"] as? [String:Any] {
                        if let ref = items["$ref"] as? String, let type = ref.components(separatedBy: "/").last {
                            arrayTypes.append((schema.name.capitalizingFirstLetter(),"[\(type.capitalizingFirstLetter())]"))
                        }
                        else
                            if var model = parseObject(name: schema.name, json: items) {
                                model.shouldBeUsedAsArray = true
                                models.append(model)
                        }
                            else if let type = items["type"] as? String {
                                var field = APIFieldD(name: schema.name, type: type)
                                field.description = schema.value.metadata.description
                                arrayTypes.append((schema.name.capitalizingFirstLetter(),"[\(field.type)]"))
                        }
                    }
                case .string:
                    if let items = schema.value.metadata.json["enum"] as? [String] {
                        var field = APIFieldD(name: schema.name, type: "string")
                        field.description = schema.value.metadata.description
                        field.cases = items
                        enums.append(field)
                    }
                default:
                    break
                }
            }
        }
        
        var requests: [APIRequestD] = []
        for operation in spec.operations {
            let method = operation.method.rawValue
            var fields:[APIFieldD] = []
            for parameter in operation.parameters {
                let json = parameter.value.json
                if let name = json["name"] as? String,
                    let required = json["required"] as? Bool,
                    let schema = json["schema"] as? [String:String] {
                    
                    if let type = schema["type"] {
                        var field = APIFieldD(name: name, type: type + (required ? "" : "?"))
                        field.description = parameter.value.description
                        fields.append(field)
                    }
                    else if let ref = schema["$ref"], let name = ref.components(separatedBy: "/").last {
                        var field = APIFieldD(name: name, type: name.capitalizingFirstLetter())
                        field.description = parameter.value.description
                        fields.append(field)
                    }
                }
            }
            
            var errorNameResponse: String = "EmptyResponse"
            var responseName: String = "EmptyResponse"
            if let responses = operation.json["responses"] as? [String:Any] {
                for response in responses {
                    if let responseJSON = response.value as? [String:Any] {
                        if response.key == "default" {
                            if let ref = responseJSON["$ref"] as? String,
                                let name = ref.components(separatedBy: "/").last {
                                errorNameResponse = name
                            }
                            else if let content = responseJSON["content"] as? [String:Any],
                                let schema = (content.values.first as? [String:Any])?.values.first as? [String:Any],
                                let ref = schema["$ref"] as? String,
                                let name = ref.components(separatedBy: "/").last{
                                errorNameResponse = name.capitalizingFirstLetter()
                            }
                        }
                        else {
                            if let content = responseJSON["content"] as? [String:Any],
                                let schema = (content.values.first as? [String:Any])?.values.first as? [String:Any] {
                                if let ref = schema["$ref"] as? String,
                                    let name = ref.components(separatedBy: "/").last{
                                    
                                    responseName = name.capitalizingFirstLetter()
                                }
                                else if let type = schema["type"] as? String {
                                    if type == "array",
                                        let items = schema["items"] as? [String:Any],
                                        let ref = items["$ref"] as? String,
                                        let name = ref.components(separatedBy: "/").last{
                                        responseName = "[\(name.capitalizingFirstLetter())]"
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if let arrType = arrayTypes.first(where: { (name,type) -> Bool in
                return name == responseName
            }) {
                responseName = arrType.type
            }
            let path = operation.path.replacingOccurrences(of: "{", with: "\\(").replacingOccurrences(of: "}", with: ")")
            let request = APIRequestD(path: path, method: method, fields: fields, responseType: responseName.capitalizingFirstLetter(),errorType: errorNameResponse.capitalizingFirstLetter(), description: operation.description)
            requests.append(request)
        }
        
        var text = ""
        for enumm in enums {
            text += SwiftWriter().writeEnum(enumm)
            text += "\n"
        }
        for model in models {
            text += SwiftWriter().writeModel(model)
            text += "\n"
        }
        
        for request in requests {
            text += SwiftWriter().writeRequest(request)
            text += "\n"
        }
        
        for word in bookedWords {
            text = text.replacingOccurrences(of: " \(word) ", with: " API\(word)")
        }
        
        
        print(text)
        try text.write(to: urlForSwiftFile, atomically: false, encoding: .utf8)
        //print(spec)
        
        let modelsJSON = models.map {$0.json()}
        let requestsJSON = requests.map {$0.json()}
        let JSON = ["models":modelsJSON,"requests":requestsJSON]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: JSON, options: .prettyPrinted)
        try? jsonData?.write(to: YmlToSwift.testUrlForTestObjects)
        
    }
    
}
