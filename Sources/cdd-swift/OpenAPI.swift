struct OpenApi : Encodable {
    var name: String
    var info: Info
    var paths: [Path]
	var components: [String : Component]

    init() {
        self.name = "hi"
        self.info = Info.init()
        self.paths = []
		self.components = Dictionary.init()
    }
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

struct Component : Encodable {
	var required: [String]
}
