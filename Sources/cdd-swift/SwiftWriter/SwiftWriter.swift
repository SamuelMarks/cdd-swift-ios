//
//  SwiftWriter.swift
//  cdd-swift
//
//  Created by Alexei on 04/07/2019.

import  Foundation
class SwiftWriter {
    
//    var requests = [APIRequestD(path: "/getPersons", method: "POST", fields: [APIFieldD(name: "filter", type: "string")], responseType: "Person"),APIRequestD(path: "/getPerson", method: "POST", fields: [APIFieldD(name: "filter", type: "string")], responseType: "[Person]")]
//    var models = [APIModelD(name:"Person", fields: [APIFieldD(name: "name", type: "string"),APIFieldD(name: "surname", type: "string")])]
    func write() {
//        let requestsText = requests.map ({ self.writeRequest($0)}).joined(separator: "\n\n")
//        let modelsText = models.map ({ self.writeModel($0)}).joined(separator: "\n\n")
        
//        print(requestsText)
//        print(modelsText)
    }
    
    func writeRequest(_ request: APIRequestD) -> String {

        let name = request.path.components(separatedBy: ["/","\\","(",")"]).map {$0.capitalizingFirstLetter()}.joined()

        var lines = ["struct " + name + "\(request.method.capitalizingFirstLetter())Request : APIRequest {",
        "\ttypealias ResponseType = " + request.responseType,
        "\ttypealias ErrorType = \(request.errorType) ",
        "\tfunc urlPath() -> String { return \"\(request.path)\" }",
        "\tfunc method() -> HTTPMethod { return .\(request.method) }"]

        request.fields.forEach { (field) in
            lines.append("\tlet \(field.name): \(field.type)")
        }
        
        
        lines.append("}\n")
        
        let text = lines.joined(separator: "\n")
        
        return text
    }
    
    func writeModel(_ model: APIModelD, additionalsTabs: String = "") -> String {
        
        var lines = ["struct " + model.name + " : Decodable {"]
        
        model.models.forEach {
            lines.append(writeModel($0, additionalsTabs: additionalsTabs + "\t"))
        }
        
        model.fields.forEach { (field) in
            lines.append("\tlet \(field.name): \(field.type)")
        }
        
        
        lines.append("}\n")
        
        let text = lines.map {additionalsTabs + $0}.joined(separator: "\n")

        return text
        
    }
    
    func writeEnum(_ field: APIFieldD) -> String {
        guard field.name.count > 0 else {
            return ""
        }
        
        var lines = ["enum " + field.name + " : " + field.type + " {"]
        
        field.cases.forEach { item in
            if item.count > 0 {
                if CharacterSet.letters.contains(item.first!.unicodeScalars.first!) {
                    lines.append("\tcase \(item) = \"" + item + "\"")
                }
                else {
                    lines.append("\tcase _\(item) = \"" + item + "\"")
                }
            }
        }
        
        lines.append("}\n")
        
        let text = lines.joined(separator: "\n")
        
        return text
    }
    
    func writeResponseEnum(name:String, cases: [String],types:[String]) {
       var lines = ["enum \(name): Decodable {",
            "\tprivate enum CodingKeys: String, CodingKey {"]
        
        lines.append(contentsOf: cases.map {"\t\tcase " + $0})
        lines.append("\t}\n")
        
        
        for (index,type) in types.enumerated() {
            lines.append("\tcase " + cases[index] + "(" + type + ")")
        }
        
        for (index,type) in types.enumerated() {
            lines.append(contentsOf: ["\tinit(from decoder: Decoder) throws {",
             "\t\tlet values = try decoder.container(keyedBy: CodingKeys.self)",
             "\t\tif let value = try? values.decode(\(type).self, forKey: .\(cases[index])) {",
                "\t\tself = .\(cases[index])(value)",
                "\t\treturn",
            "\t}"])
        }
        lines.append(contentsOf:["\tthrow PostTypeCodingError.decoding(\"Whoops! \\(dump(values))\")",
                                 "}",
                                 "}\n"])
    }
}
