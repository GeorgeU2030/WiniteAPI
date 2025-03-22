import Fluent

struct CreateSeason: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("seasons")
            .id()
            .field("title", .string, .required)
            .field("image", .string, .required)
            .field("wins", .int, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("seasons").delete()
    }
}