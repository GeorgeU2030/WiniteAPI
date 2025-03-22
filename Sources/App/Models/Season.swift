import Vapor
import Fluent

final class Season: Model, Content, @unchecked Sendable {
    static let schema = "seasons"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String 
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "wins")
    var wins: Int
    
    @OptionalParent(key: "best_skin_id")
    var bestSkin: SkinSeason?
    
    @Children(for: \.$season)
    var skinSeason: [SkinSeason]
    
    init() { }
    
    init(id: UUID? = nil, image: String, title: String, wins: Int, bestSkinID: UUID? = nil) {
        self.id = id
        self.image = image
        self.title = title
        self.wins = wins
        if let bestSkinID = bestSkinID {
            self.$bestSkin.id = bestSkinID
        } else {
            self.$bestSkin.id = nil
        }
    }
}