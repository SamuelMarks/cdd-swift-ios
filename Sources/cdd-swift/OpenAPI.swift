public struct OpenApi : Encodable {
    var name: String
    var info: Info
    var paths: Dictionary<String, Dictionary<String, Path>>
	var components: Dictionary<String, Dictionary<String, SchemaComponent>>

    init() {
        self.name = "hi"
        self.info = Info.init()
		self.paths = [:]
		self.components = [:]
		self.components["schemas"] = [:]
    }
}

public struct SchemaComponent: Encodable {
	public let type: String
	public let properties: Dictionary<String, ComponentField>
}

public struct ComponentField: Encodable {
	public let type: String
	public let format: String
}

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
	var operationId: String
	var parameters: [RouteParameter]
	var responses: [RouteResponse]
}

struct Route : Encodable {
	var operationId: String
	var parameters: [RouteParameter]
	var responses: [RouteResponse]
}

struct RouteParameter : Encodable {}

struct RouteResponse : Encodable {}
