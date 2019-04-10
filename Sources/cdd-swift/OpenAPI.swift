public struct OpenApi : Encodable {
    var name: String
    var info: Info
    var paths: [Path]
	var components: Components

    init() {
        self.name = "hi"
        self.info = Info.init()
        self.paths = []
		self.components = Components.init(schemas: [:])
    }
}

public struct Schema: Encodable {
}

extension Schema: Component {
	public static let componentType: ComponentType = .schema
}

public struct Properties : Encodable {
//	public var property: Dictionary<String, String>
//	public var property: [(String, String)]
}

public struct Components : Encodable {
	public var schemas: Dictionary<String, ComponentObject>
}

public struct ComponentField: Encodable {
	public let type: String
	public let format: String
}

public protocol Component : Encodable {
	static var componentType: ComponentType { get }
}

public enum ComponentType: String, Encodable {
	case schema = "schemas"
	case response = "responses"
}

//public enum PropertyType: Encodable {
//	case int64
//	case int32
//	case datetime
//	case string
//}

//public struct IntegerSchema: FieldType, Encodable {
//	let type: String
//	let format: String
//}

public protocol FieldComponent: Encodable {

}

//public struct ComponentProperty: Encodable {
//	type: String
//	format: PropertyType
//}
//
public struct ComponentObject: Encodable {
	public let type: String
	public let properties: Dictionary<String, ComponentField>
}

struct Info : Encodable {
    var title: String
    var version: String

    init() {
        self.title = "Simple API overview"
        self.version = "2.0.0"
    }
}

struct Path : Encodable {
    var route: Route
}

struct Route : Encodable {
    var method: Method
}

struct Method : Encodable {
    var type: String // GET, PUT, etc
}
