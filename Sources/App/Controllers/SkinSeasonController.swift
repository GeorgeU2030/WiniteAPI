import Vapor
import Fluent

struct SkinSeasonController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let skinSeasonRoutes = routes.grouped("skinseasons")
        skinSeasonRoutes.post(use: create)
        skinSeasonRoutes.get(use: index)
        skinSeasonRoutes.patch("update-wins", use: updateWins)
    }
    
    func index(req: Request) async throws -> [SkinSeason] {
        try await SkinSeason.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> SkinSeason {
        let skinSeasonRequest = try req.content.decode(SkinSeasonRequest.self)
        
        let skinSeason = SkinSeason(
            name: skinSeasonRequest.name,
            image: skinSeasonRequest.image,
            wins: skinSeasonRequest.wins,
            seasonID: skinSeasonRequest.seasonID
        )
        
        try await skinSeason.save(on: req.db)
        return skinSeason
    }
    
    func updateWins(req: Request) async throws -> SkinSeason {
        
        struct updateWinsRequest: Content {
            var id: UUID
            var wins: Int
        }
        
        let updateRequest = try req.content.decode(updateWinsRequest.self)
        
        guard let skinSeason = try await SkinSeason.query(on: req.db)
            .filter(\.$id == updateRequest.id)
            .first() else {
            throw Abort(.notFound, reason: "SkinSeason not found")
        }
        
        let seasonId = skinSeason.$season.id

        skinSeason.wins = updateRequest.wins
        try await skinSeason.save(on: req.db)
        
        let totalWins = try await SkinSeason.query(on: req.db)
        .filter(\.$season.$id == seasonId)
        .all()
        .reduce(0) { $0 + $1.wins }
    
        if let season = try await Season.find(seasonId, on: req.db) {
            season.wins = totalWins 
            try await season.save(on: req.db)
        }

        if let existSkin = try await Skin.query(on: req.db)
            .filter(\.$name == skinSeason.name)
            .first() {
            existSkin.totalWins = updateRequest.wins
            try await existSkin.save(on: req.db)
        }
        
        return skinSeason
    }

}