import Foundation

public struct Pet: APIModel {
    public var id: Int
    public var name: String
    public var tag: String?
}
