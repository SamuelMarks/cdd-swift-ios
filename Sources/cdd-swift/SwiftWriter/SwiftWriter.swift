//
//  SwiftWriter.swift
//  cdd-swift
//
//  Created by Alexei on 04/07/2019.


class SwiftWriter {
    
    var requests = [APIRequestD(path: "/getPersons", method: "POST", fields: [APIFieldD(name: "filter", type: "string")], responseType: "Person"),APIRequestD(path: "/getPerson", method: "POST", fields: [APIFieldD(name: "filter", type: "string")], responseType: "[Person]")]
    var models = [APIModelD(name:"Person", fields: [APIFieldD(name: "name", type: "string"),APIFieldD(name: "surname", type: "string")])]
    func write() {
        let requestsText = requests.map ({ self.writeRequest($0)}).joined(separator: "\n\n")
        let modelsText = models.map ({ self.writeModel($0)}).joined(separator: "\n\n")
        
        print(requestsText)
        print(modelsText)
    }
    
    func writeRequest(_ request: APIRequestD) -> String {
        let method = request.method.lowercased()
        let name = request.path.components(separatedBy: "/").map {$0.capitalizingFirstLetter()}.joined()

        var lines = ["struct " + name + " : APIRequest {",
        "\ttypealias ResponseType = " + request.responseType,
        "\tfunc path() -> String { return \"\(request.path)\" }",
        "\tfunc method() -> HTTPMethod { return .\(method) }"]

        request.fields.forEach { (field) in
            lines.append("\tlet \(field.name): \(field.type.capitalizingFirstLetter())")
        }
        
        
        lines.append("}")
        
        let text = lines.joined(separator: "\n")
        
        return text
    }
    
    func writeModel(_ model: APIModelD) -> String {
        
        var lines = ["struct " + model.name + " : APIResponse {"]
        
        model.fields.forEach { (field) in
            lines.append("\tlet \(field.name): \(field.type.capitalizingFirstLetter())")
        }
        
        
        lines.append("}")
        
        let text = lines.joined(separator: "\n")

        return text
        
    }
}
