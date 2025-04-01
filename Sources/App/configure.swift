import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
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

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    
    app.middleware.use(cors, at: .beginning)

    // register routes
    try routes(app)
}
