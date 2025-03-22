import Vapor
import Fluent

struct SkinController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let skinRoutes = routes.grouped("skins")
        skinRoutes.post(use: create)
        skinRoutes.get(use: index)
    }
    
    func index(req: Request) async throws -> [Skin] {
        try await Skin.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Skin {
        let skin = try req.content.decode(Skin.self)
        try await skin.save(on: req.db)
        return skin
    }
}