import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                username: "postgres",
                password: "12345",
                database: "winite",
                tls: .disable
            )
        ),
        as: .psql
    )
    
    app.migrations.add(CreateSeason())       
    app.migrations.add(CreateSkinSeason())   
    app.migrations.add(CreateSkin())         
    app.migrations.add(AddBestSkin())
    
    try await app.autoMigrate()
}
