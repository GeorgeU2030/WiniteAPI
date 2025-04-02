import Vapor

struct SeasonResponse: Content {
    let season: Season
    let skins: [SkinSeason]
}
