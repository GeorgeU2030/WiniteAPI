import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "Winite works!"
    }
    
    let seasonRoutes = SeasonController()
    try app.register(collection: seasonRoutes)
}
