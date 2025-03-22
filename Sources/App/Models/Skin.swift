import Vapor
import Fluent
import FluentPostgresDriver

final class Skin: Model, Content, @unchecked Sendable {
    
    static let schema = "skins"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "total_wins")
    var totalWins: Int
    
    init() { }
    
    init(id: UUID? = nil, name: String, image: String, totalWins: Int) {
        self.id = id
        self.name = name
        self.image = image
        self.totalWins = totalWins
    }
    
}