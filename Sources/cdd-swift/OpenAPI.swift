public struct OpenApi : Encodable {
    var name: String
    var info: Info
    var paths: [Path]
	var components: Components

    init() {
        self.name = "hi"
        self.info = Info.init()
        self.paths = []
		self.components = Components.init(schemas: [])
    }
}

public struct Schema: Encodable {
}

extension Schema: Component {
	public static let componentType: ComponentType = .schema
}

public struct Components : Encodable {
	public let schemas: [ComponentObject<Schema>]
}

public protocol Component : Encodable {
	static var componentType: ComponentType { get }
}

public enum ComponentType: String, Encodable {
	case schema = "schemas"
}


public struct ComponentObject<T: Component>: Encodable {
	public let name: String
	public let value: T
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

//struct Component : Encodable {
//	var required: [String]
//}
