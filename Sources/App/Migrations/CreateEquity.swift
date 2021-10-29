import Fluent

struct CreateEquity: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("securities")
        
            .id()
            .field("tiker", .string, .required)
            .field("type", .string, .required)
            .field("price", .float, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("securities").delete()
    }
}
