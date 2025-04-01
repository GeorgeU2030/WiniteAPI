import Vapor
import Fluent

struct SkinController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let skinRoutes = routes.grouped("skins")
        skinRoutes.post(use: create)
        skinRoutes.get(use: index)
        skinRoutes.get(":name", use: getOne)
    }
    
    func index(req: Request) async throws -> [Skin] {
        try await Skin.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Skin {
        let skin = try req.content.decode(Skin.self)
        try await skin.save(on: req.db)
        return skin
    }

    func getOne(req: Request) async throws -> Skin {
        let skinName = try req.parameters.require("name", as: String.self)
        
        guard let skin = try await Skin.query(on: req.db)
            .filter(\.$name == skinName)
            .first() else {
            throw Abort(.notFound)
        }
        
        return skin
    }
}