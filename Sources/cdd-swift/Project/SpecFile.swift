//
//  SpecFile.swift
//  CYaml
//
//  Created by Rob Saunders on 7/16/19.
//

import Foundation
import Yams

struct SpecFile: ProjectSource {
	let path: URL
	let modificationDate: Date
	var syntax: SwaggerSpec

	mutating func apply(projectInfo: ProjectInfo) {
		let hostname = projectInfo.hostname.absoluteString
		if !self.syntax.servers.map({$0.url}).contains(projectInfo.hostname.absoluteString) {
			self.syntax.servers.append(Server(name: nil, url: hostname, description: nil, variables: [:]))
		}
	}
    
    mutating func apply(project: Project) {
        
    }
    
    mutating func update(request:Request) {
        checkForComplexResponse(request: request)
        guard let pathIndex = syntax.paths.firstIndex(where:{$0.path == request.urlPath}) else { return }
        var path = syntax.paths[pathIndex]
        guard let method = Operation.Method(rawValue: request.method.rawValue) else { return }
        guard let operationIndex = path.operations.firstIndex(where: {$0.method == method}) else { return }

        let parameters = request.vars.map { PossibleReference.value($0.parameter()) }
        let response = request.response()
        let responses: [OperationResponse] = response == nil ? [] : [response!]
        let defaultResponse: PossibleReference<Response>? = request.defaultResponse()

        let operation = Operation(json: [:], path: request.urlPath, method: method, summary: nil, description: nil, requestBody: nil, pathParameters: [], operationParameters: parameters, responses: responses, defaultResponse: defaultResponse, deprecated: false, identifier: nil, tags: [], securityRequirements: nil)

        path.operations[operationIndex] = operation
        syntax.paths[pathIndex] = path
		log.eventMessage("UPDATED \(request.name) in specfile")
    }
    
    
    mutating func update(model:Model) {
        guard let index = syntax.components.schemas.firstIndex(where: {$0.name == model.name}) else {return}
        var schema = syntax.components.schemas[index]
        
        let properties = schemas(from: model.vars)
        
        schema.value.type = objectType(for: properties)
        syntax.components.schemas[index] = schema
		log.eventMessage("UPDATED \(model.name) in specfile")
    }
    

    mutating func remove(model:Model) {
        for (index, specModel) in self.syntax.components.schemas.enumerated() {
            if model.name == specModel.name {
                self.syntax.components.schemas.remove(at: index)
                print("REMOVED \(model.name) from specfile")
            } else {
                exitWithError("critical error: could not remove \(model.name) from spec")
            }
        }
    }
    
    mutating func insert(model:Model) {
        let properties = schemas(from: model.vars)
        let schema = Schema(metadata: Metadata(jsonDictionary: ["type":"object"]), type: objectType(for: properties))
        self.syntax.components.schemas.append(ComponentObject(name: model.name, value: schema))
    }
    
    mutating func remove(request:Request) {
        let method = Operation.Method(rawValue: request.method.rawValue) ?? .post
        if var path = syntax.paths.first(where:{$0.path == request.urlPath}) {
            path.operations.removeAll(where: {$0.method == method})
            if path.operations.count == 0 {
                syntax.paths.removeAll(where: {$0.path == request.urlPath})
            }
        }
    }
    
    mutating func checkForComplexResponse(request:Request) {
        if request.responseType != request.swaggerResponseType {
            let singleObjectType = request.responseType.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
            
            let type = "#/components/schemas/" + singleObjectType
            let ref = Reference<Schema>(type)
            
            let objects = syntax.components.schemas
            if let object = objects.first(where: { $0.name == singleObjectType }) {
                ref.resolve(with: object.value)
            }
            
            let schemaRef = Schema(metadata: Metadata(jsonDictionary: ["type":"array"]), type: .reference(ref))
            
            let arrSchema = ArraySchema(items: .single(schemaRef), minItems: nil, maxItems: nil, additionalItems: nil, uniqueItems: false)
            
            let schema = Schema(metadata: Metadata(jsonDictionary: ["type":"object"]), type: .array(arrSchema))
            self.syntax.components.schemas.append(ComponentObject(name: request.swaggerResponseType, value: schema))
        }
    }
    
    mutating func insert(request:Request) {
        checkForComplexResponse(request: request)

        let parameters = request.vars.map { PossibleReference.value($0.parameter()) }
        let response = request.response()
        let responses: [OperationResponse] = response == nil ? [] : [response!]
        let defaultResponse: PossibleReference<Response>? = request.defaultResponse()
        var path = syntax.paths.first(where:{$0.path == request.urlPath}) ?? Path(path: request.urlPath, operations: [], parameters: [])
        let method = Operation.Method(rawValue: request.method.rawValue) ?? .post

        let operation = Operation(json: [:], path: request.urlPath, method: method, summary: nil, description: nil, requestBody: nil, pathParameters: [], operationParameters: parameters, responses: responses, defaultResponse: defaultResponse, deprecated: false, identifier: nil, tags: [], securityRequirements: nil)
        path.operations.append(operation)
        if let pathIndex = syntax.paths.firstIndex(where:{$0.path == request.urlPath}) {
            syntax.paths[pathIndex] = path
        }
        else {
            syntax.paths.append(path)
        }
    }
    
	func generateProject() -> Project {
		return Project.fromSwagger(self)!
	}

	func contains(model name: String) -> Bool {
		return self.syntax.components.schemas.contains(where: {$0.name == name})
	}

	func toYAML() -> Result<String, Swift.Error> {
		do {
			let encoder = YAMLEncoder()
			let encodedYAML = try encoder.encode(self.syntax)
			return .success(encodedYAML)
		}
		catch let err {
			return .failure(err)
		}
	}
    
    func schemas(from variables:[Variable]) -> [Property] {
        return variables.map({$0.property()})
    }
    
    func objectType(for properties: [Property]) -> SchemaType {
        let requiredProperties = properties.filter { $0.required }
        let optionalProperties = properties.filter { !$0.required }
        
        return .object(ObjectSchema(requiredProperties: requiredProperties, optionalProperties: optionalProperties, properties: properties, minProperties: nil, maxProperties: nil, additionalProperties: nil, abstract: false, discriminator: nil))
    }
}


private extension Request {
    func response() -> OperationResponse? {
        if responseType == "EmptyResponse" {
            return nil
        }
        
        let schema = Schema(metadata: Metadata(jsonDictionary: [:]), type: .reference(Reference("#/components/schemas/" + swaggerResponseType)))
        let content = Content(mediaItems: [Content.MediaType.json.rawValue:MediaItem(schema: schema)])
        let response = Response(description: "", content: content, headers: [:])
        return OperationResponse(statusCode: 200, response: .value(response))
    }
    
    func defaultResponse() -> PossibleReference<Response>? {
        if errorType == "EmptyResponse" {
            return nil
        }
        
        let schema = Schema(metadata: Metadata(jsonDictionary: [:]), type: .reference(Reference("#/components/schemas/" + swaggerResponseType)))
        let content = Content(mediaItems: [Content.MediaType.json.rawValue:MediaItem(schema: schema)])
        let response = Response(description: "", content: content, headers: [:])
        
        return .value(response)
    }
}
