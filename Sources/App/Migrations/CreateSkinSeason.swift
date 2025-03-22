import Fluent

struct CreateSkinSeason: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("skin_seasons")
            .id()
            .field("name", .string, .required)
            .field("image", .string, .required)
            .field("wins", .int, .required)
            .field("season_id", .uuid, .required, .references("seasons", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("skin_seasons").delete()
    }
}