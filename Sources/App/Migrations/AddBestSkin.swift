import Fluent

struct AddBestSkin: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("seasons")
            .field("best_skin_id", .uuid, .references("skin_seasons", "id", onDelete: .setNull))
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("seasons")
            .deleteField("best_skin_id")
            .update()
    }
}