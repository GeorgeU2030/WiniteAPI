import Vapor
import Fluent
import FluentPostgresDriver

final class SkinSeason: Model, Content, @unchecked Sendable {
    static let schema = "skin_seasons"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "wins")
    var wins: Int
    
    @Parent(key: "season_id")
    var season: Season
    
    init() { }
    
    init(id: UUID? = nil, name: String, image: String, wins: Int, seasonID: UUID) {
        self.id = id
        self.name = name
        self.image = image
        self.wins = wins
        self.$season.id = seasonID
    }
}