//
//  WriteToYmlTest.swift
//  cdd-swift
//
//  Created by Alexei on 10/07/2019.
//


import Foundation

class WriteToYmlTest {
    let testUrl = URL(fileURLWithPath: "/Users/alexei/Documents/Projects/cdd-swift-ios/Examples/petstore.yml")

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
    
    func run() throws {
        let spec:SwaggerSpec = try getSpec(url: testUrl)
        
        guard let data = try? JSONEncoder().encode(spec),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return
        }
        
        
        print(json)
        
//        if let jsonData = try? JSONSerialization.data(withJSONObject: spec.json, options: .prettyPrinted),
//        let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]  {
//            print(json)
//        }
        
        
    }
}
