import JSONUtilities

extension Reference : Encodable {
    enum CodingKeys: String, CodingKey {
        case ref = "$ref"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(string, forKey: .ref)
    }
}

public class Reference<T: Component> {

    let string: String

    private var _value: T?
    public var value: T {
        guard let value = _value else {
            fatalError("Reference \(string) is unresolved")
        }
        return value
    }

    public let name: String

    public init(_ string: String) {
        self.string = string
        name = string.components(separatedBy: "/").last!
    }

    public convenience init(jsonDictionary: JSONDictionary) throws {
        let string: String = try jsonDictionary.json(atKeyPath: "$ref")
        self.init(string)
    }

    public var component: ComponentObject<T> {
        return ComponentObject(name: name, value: value)
    }

    func resolve(with value: T) {
        _value = value
    }

    func getReferenceComponent(index: Int) -> String? {
        let components = string.components(separatedBy: "/")
        guard components.count > index else { return nil }
        return components[index]
    }

    public var referenceType: String? {
        return getReferenceComponent(index: 2)
    }

    public var referenceName: String? {
        return getReferenceComponent(index: 3)
    }
}

extension PossibleReference : Encodable {
    enum CodingKeys: String, CodingKey {
        case componentType
        case ref = "$ref"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .value(let value):
            if let parametr = value as? Parameter {
                try parametr.encode(to: encoder)
            }
            else
                if let response = value as? Response {
                    try response.encode(to: encoder)
                }
                else if let header = value as? Header {
                    try header.encode(to: encoder)
            }
        case .reference(let ref):
            print(ref.string)
            try container.encode(ref.string, forKey: .ref)
        }
    }
}


public enum PossibleReference<T: Component & Encodable>: JSONObjectConvertible {

    case reference(Reference<T>)
    case value(T)

    public var value: T {
        switch self {
        case let .reference(reference): return reference.value
        case let .value(value): return value
        }
    }

    public var name: String? {
        if case let .reference(reference) = self {
            return reference.name
        }
        return nil
    }

    public var swaggerObject: ComponentObject<T>? {
        if case let .reference(reference) = self {
            return reference.component
        }
        return nil
    }

    public init(jsonDictionary: JSONDictionary) throws {
        if let reference: String = jsonDictionary.json(atKeyPath: "$ref") {
            self = .reference(Reference<T>(reference))
        } else {
            self = .value(try T(jsonDictionary: jsonDictionary))
        }
    }
}
