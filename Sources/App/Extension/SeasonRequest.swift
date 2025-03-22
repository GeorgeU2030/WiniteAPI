import Vapor

struct SeasonRequest: Content {
    var title: String
    var image: String
    var wins: Int
}