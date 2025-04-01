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
        try await Season.query(on: req.db).all()
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

    func getOne(req: Request) async throws -> Season {
        let seasonId = try req.parameters.require("seasonId", as: UUID.self)

        guard let season = try await Season.query(on: req.db)
            .filter(\.$id == seasonId)
            .with(\.$skinSeason) 
            .with(\.$bestSkin)   
            .first() else {
            throw Abort(.notFound)
        }

        return season
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