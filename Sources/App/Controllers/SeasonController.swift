import Vapor
import Fluent

struct SeasonController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let seasonroutes = routes.grouped("seasons")
        seasonroutes.post(use: create)
        seasonroutes.get(use: index)
        seasonroutes.patch(":seasonId", "best-skin", use: updateBestSkin)
        seasonroutes.get(":seasonId", use: getOne)
    }
    
    func index(req: Request) async throws -> [Season] {
        try await Season.query(on: req.db)
        .with(\.$bestSkin)
        .sort(\.$wins, .descending)
        .all()
    }
    
    func create(req: Request) async throws -> Season {
        let seasonRequest = try req.content.decode(SeasonRequest.self)
        
        let season = Season(
            image: seasonRequest.image,
            title: seasonRequest.title,
            wins: seasonRequest.wins
        )
        
        try await season.save(on: req.db)
        return season
    }

    func getOne(req: Request) async throws -> SeasonResponse {
        let seasonId = try req.parameters.require("seasonId", as: UUID.self)
    
        // Obtener la temporada
        guard let season = try await Season.query(on: req.db)
            .filter(\.$id == seasonId)
            .with(\.$bestSkin)
            .first() else {
            throw Abort(.notFound)
        }
    
        let skins = try await SkinSeason.query(on: req.db)
            .filter(\.$season.$id == seasonId)
            .sort(\.$wins, .descending)
            .all()
    
        return SeasonResponse(season: season, skins: skins)
    }
    
    func updateBestSkin(req: Request) async throws -> Season {
        let seasonId = try req.parameters.require("seasonId", as: UUID.self)
        
        struct updateBestSkinRequest: Content {
            var bestSkinID: UUID
        }
        
        let updateRequest = try req.content.decode(updateBestSkinRequest.self)
        
        guard let season = try await Season.find(seasonId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        season.$bestSkin.id = updateRequest.bestSkinID
        
        try await season.save(on: req.db)
        return season
    }
}