import Fluent

struct CreateSkin: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("skins")
            .id()
            .field("name", .string, .required)
            .field("image", .string, .required)
            .field("total_wins", .int, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("skins").delete()
    }
}