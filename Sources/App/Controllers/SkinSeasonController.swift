import Vapor
import Fluent

struct SkinSeasonController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let skinSeasonRoutes = routes.grouped("skinseasons")
        skinSeasonRoutes.post(use: create)
        skinSeasonRoutes.get(use: index)
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

}