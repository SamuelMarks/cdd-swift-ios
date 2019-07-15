////
////  Project_Swagger.swift
////  cdd-swift
////
////  Created by Alexei on 14/07/2019.
////
//import Foundation
//
//private extension String {
//    func formated() -> String {
//        let bookedWords = ["Error","Class"]
//        var text = self.capitalizingFirstLetter()
//        for word in bookedWords {
//            text = text.replacingOccurrences(of: word, with: "API\(word)")
//        }
//        return text
//    }
//}
//extension PrimitiveType {
//    static func fromSwagger(string: String) -> PrimitiveType? {
//        if string == "integer" {
//            return .Int
//        }
//        else if string == "number" {
//            return .Float
//        }
//        else if string == "boolean" {
//            return .Bool
//        }
//        return .String
//    }
//}
//
//extension Project {
//    
//    private static func generateRequestName(path:String, method:String) -> String {
//        return path.components(separatedBy: ["/","\\","(",")","{","}"]).map {$0.formated()}.joined() + method.formated() + "Request"
//    }
//    
//    private static func parseType(_ json: [String:Any], couldBeObjectName: String = "") -> (Type?,Model?) {
//        if let type = json["type"] as? String {
//            if type == "array", let items = json["items"] as? [String:Any] {
//                let res = parseType(items, couldBeObjectName: couldBeObjectName)
//                if let type = res.0 {
//                    return (.array(type), res.1)
//                }
//                else {
//                    return (nil, res.1)
//                }
//            }
//            else
//                if type == "object" {
//                    if let model = parseObject(name: couldBeObjectName, json: json) {
//                        return (.complex(couldBeObjectName), model)
//                    }
//                }
//                else if let type = PrimitiveType.fromSwagger(string: type) {
//                    return (.primitive(type),nil)
//            }
//        }
//        
//        return (nil,nil)
//    }
//    
//    private static func parseObject(name: String, json: [String:Any]) -> Model? {
//        guard let properties = json["properties"] as? [String:[String:Any]] else { return nil }
//        let required = (json["required"] as? [String]) ?? []
//        var fields: [Variable] = []
//        var additionalModels: [Model] = []
//        for property in properties {
//            let result = parseType(property.value, couldBeObjectName: property.key)
//            if let model = result.1 {
//                additionalModels.append(model)
//            }
//            if let type = result.0 {
//                var field = Variable(name: property.key)
//                field.optional = !required.contains(property.key)
//                field.type = type
//                field.description = property.value["description"] as? String
//                fields.append(field)
//            }
//        }
//        var model = Model(name: name, vars: fields)
////        model.models = additionalModels /// Need to finish
//        return model
//    }
//    
//
//    
//    static func fromSwagger(_ spec: SwaggerSpec) -> Project? {
//        
//        var arrayTypes: [(name:String,type:String)] = []
//        var models:[Model] = []
//        var enums: [APIFieldD] = [] // need to finish
//        for schema in spec.components.schemas {
//            if let dataType = schema.value.metadata.type {
//                switch dataType {
//                case .object:
//                    if let model = parseObject(name: schema.name.formated(), json: schema.value.metadata.json) {
//                        models.append(model)
//                    }
//                case .array:
//                    if let items = schema.value.metadata.json["items"] as? [String:Any] {
//                        if let ref = items["$ref"] as? String, let type = ref.components(separatedBy: "/").last {
//                            arrayTypes.append((schema.name.formated(),"[\(type.formated())]"))
//                        }
//                        else
//                            if var model = parseObject(name: schema.name, json: items) {
////                                model.shouldBeUsedAsArray = true /// need to finish
//                                models.append(model)
//                            }
//                            else if let type = items["type"] as? String {
//                                var field = APIFieldD(name: schema.name, type: type)
//                                field.description = schema.value.metadata.description
//                                arrayTypes.append((schema.name.formated(),"[\(field.type)]"))
//                        }
//                    }
//                case .string:
//                    if let items = schema.value.metadata.json["enum"] as? [String] {
//                        var field = APIFieldD(name: schema.name, type: "string")
//                        field.description = schema.value.metadata.description
//                        field.cases = items
//                        enums.append(field)
//                    }
//                default:
//                    break
//                }
//            }
//        }
//        
//        var requests: [Request] = []
//        for operation in spec.operations {
//            let method = operation.method.rawValue
//            var fields:[Variable] = []
//            for parameter in operation.parameters {
//                let json = parameter.value.json
//                if let name = json["name"] as? String,
//                    let required = json["required"] as? Bool,
//                    let schema = json["schema"] as? [String:String] {
//                    
//                    if let typeRaw = schema["type"], let type = PrimitiveType.fromSwagger(string: typeRaw) {
//                        var field = Variable(name: name)
//                        field.type = .primitive(type)
//                        field.optional = !required
//                        field.description = parameter.value.description
//                        fields.append(field)
//                    }
//                    else if let ref = schema["$ref"], let name = ref.components(separatedBy: "/").last {
//                        var field = Variable(name: name)
//                        field.type = .complex(name.formated())
//                        field.optional = !required
//                        field.description = parameter.value.description
//                        fields.append(field)
//                    }
//                }
//            }
//            
//            var errorNameResponse: String = "EmptyResponse"
//            var responseName: String = "EmptyResponse"
//            if let responses = operation.json["responses"] as? [String:Any] {
//                for response in responses {
//                    if let responseJSON = response.value as? [String:Any] {
//                        if response.key == "default" {
//                            if let ref = responseJSON["$ref"] as? String,
//                                let name = ref.components(separatedBy: "/").last {
//                                errorNameResponse = name
//                            }
//                            else if let content = responseJSON["content"] as? [String:Any],
//                                let schema = (content.values.first as? [String:Any])?.values.first as? [String:Any],
//                                let ref = schema["$ref"] as? String,
//                                let name = ref.components(separatedBy: "/").last{
//                                errorNameResponse = name.formated()
//                            }
//                        }
//                        else {
//                            if let content = responseJSON["content"] as? [String:Any],
//                                let schema = (content.values.first as? [String:Any])?.values.first as? [String:Any] {
//                                if let ref = schema["$ref"] as? String,
//                                    let name = ref.components(separatedBy: "/").last{
//                                    
//                                    responseName = name.formated()
//                                }
//                                else if let type = schema["type"] as? String {
//                                    if type == "array",
//                                        let items = schema["items"] as? [String:Any],
//                                        let ref = items["$ref"] as? String,
//                                        let name = ref.components(separatedBy: "/").last{
//                                        responseName = "[\(name.formated())]"
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            if let arrType = arrayTypes.first(where: { (name,type) -> Bool in
//                return name == responseName
//            }) {
//                responseName = arrType.type
//            }
//            let path = operation.path
//            
//            let request = Request(name: generateRequestName(path: path, method: method),
//                                  method: Method(rawValue: method) ?? .post,
//                                  urlPath: path,
//                                  responseType: responseName,
//                                  errorType: errorNameResponse,
//                                  vars: fields)
//            requests.append(request)
//        }
//
//        
//        guard let path = spec.servers.first?.url, let url = URL(string:path) else { return nil }
//        
//        
//        return Project(info: ProjectInfo(modificationDate: Date(), hostname: url), models: models, requests: requests)
//    }
//    
//}
