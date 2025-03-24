import Vapor

struct SkinSeasonRequest: Content {
    var name: String
    var image: String
    var wins: Int
    var seasonID: UUID
}