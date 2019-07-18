//
//  Project_Compare.swift
//  cdd-swift
//
//  Created by Alexei on 14/07/2019.
//

import Foundation


//    mutating func apply(_ changes: [Change]) {
//        
//        for change in changes {
//            switch change {
//            case .insertion(let change):
//                
//                switch change {
//                case .model(let model, _):
//                    let properties = schemas(from: model.vars)
//                    let schema = Schema(metadata: Metadata(jsonDictionary: ["type":"object"]), type: objectType(for: properties))
//                    components.schemas.append(ComponentObject(name: model.name, value: schema))
//                case .request(let request, _):
//                    let parameters = request.vars.map { PossibleReference.value($0.parameter()) }
//                    let response = request.response()
//                    let responses: [OperationResponse] = response == nil ? [] : [response!]
//                    let defaultResponse: PossibleReference<Response>? = request.defaultResponse()
//                    var path = paths.first(where:{$0.path == request.urlPath}) ?? Path(path: request.urlPath, operations: [], parameters: [])
//                    let method = Operation.Method(rawValue: request.method.rawValue) ?? .post
//                    
//                    let operation = Operation(json: [:], path: request.urlPath, method: method, summary: nil, description: nil, requestBody: nil, pathParameters: [], operationParameters: parameters, responses: responses, defaultResponse: defaultResponse, deprecated: false, identifier: nil, tags: [], securityRequirements: nil)
//                    path.operations.append(operation)
//                    if paths.first(where:{$0.path == request.urlPath}) == nil {
//                        paths.append(path)
//                    }
//                    break
//                }
//                
//            case .deletion(let change):
//                
//                switch change {
//                case .model(let model, _):
//                    if let needToDeleteIndex = self.components.schemas.firstIndex(where: {$0.name == model.name}) {
//                        self.components.schemas.remove(at: needToDeleteIndex)
//                    }
//                    
//                case .request(let request, _):
//                    let method = Operation.Method(rawValue: request.method.rawValue) ?? .post
//                    if var path = paths.first(where:{$0.path == request.urlPath}) {
//                        path.operations.removeAll(where: {$0.method == method})
//                        if path.operations.count == 0 {
//                            paths.removeAll(where: {$0.path == request.urlPath})
//                        }
//                    }
//                }
//                
//            case .update(let change):
//                switch change {
//                case .model(let model, let update):
//                    guard let update = update else { return }
//                    guard let index = components.schemas.firstIndex(where: {$0.name == model.name}) else {return}
//                    var schema = components.schemas[index]
//                    guard case .object(let object) = schema.value.type else { return }
//                    var properties = object.properties
//                    switch update {
//                    case .deletion(let variable):
//                        properties.removeAll(where: {$0.name == variable.name})
//                        
//                        schema.value.type = objectType(for: properties)
//                        components.schemas[index] = schema
//                        break
//                    case .insertion(let variable):
//                        properties.append(variable.property())
//                        break
//                    case .update(let name, let changes):
//                        guard let index = properties.firstIndex(where: {$0.name == name}) else { return }
//                        var property = properties[index]
//                        for change in changes {
//                            switch change {
//                            case .optional(let optional):
//                                property.required = !optional
//                            case .type(let newType):
//                                property.schema = newType.schema()
//                            case .value(_):
//                                break
//                            }
//                        }
//                        properties[index] = property
//                        
//                        break
//                    }
//                    components.schemas[index] = schema
//                    schema.value.type = objectType(for: properties)
//                    components.schemas[index] = schema
//                    
//                case .request(let request, let update):
//                    guard let update = update else { return }
//                    guard var pathIndex = paths.firstIndex(where:{$0.path == request.urlPath}) else { return }
//                    var path = paths[pathIndex]
//                    guard let method = Operation.Method(rawValue: request.method.rawValue) else { return }
//                    guard let operationIndex = path.operations.firstIndex(where: {$0.method == method}) else { return }
//                    var operation = path.operations[operationIndex]
//                    var parameters = operation.operationParameters
//                    
//                    switch update {
//                    case .deletion(let variable):
//                        parameters.removeAll { (reference) -> Bool in
//                            if case .value(let parameter) = reference {
//                                return parameter.name == variable.name
//                            }
//                            return false
//                        }
//                        
//                    case .insertion(let variable):
//                        parameters.append(.value(variable.parameter()))
//                        
//                    case .update(let name, let changes):
//                        guard let index = parameters.firstIndex(where: {$0.name == name}) else { return }
//                        guard case .value(var parameter) = parameters[index] else { return }
//                        for change in changes {
//                            switch change {
//                            case .optional(let optional):
//                                parameter.required = !optional
//                            case .type(let newType):
//                                let parType = ParameterType.schema(ParameterSchema(schema: newType.schema(), serializationStyle: .simple, explode: false))
//                                parameter.type = parType
//                            case .value(_):
//                                break
//                            }
//                        }
//                        parameters[index] = .value(parameter)
//                    case .responseType(_):
//                        let response = request.response()
//                        let responses: [OperationResponse] = response == nil ? [] : [response!]
//                        operation.responses = responses
//                    case .errorType(_):
//                        operation.defaultResponse = request.defaultResponse()
//                    case .path(_):
//                        break// if changed so it will be new request
//                    case .method(_):
//                        break// if changed so it will be new request
//                    }
//                    
//                    operation.operationParameters = parameters
//                    path.operations[operationIndex] = operation
//                    paths[pathIndex] = path
//                    break
//                }
//            }
//        }
//        
//        if let data = try? JSONEncoder().encode(self),
//        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
//        let spec = try? SwaggerSpec(jsonDictionary: json) {
//            self = spec
//        }
//    }
//}
//
