import Fluent

struct CreateSecurityUserPivot: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("security-user-pivot")
      .id()
      .field("securityID", .uuid, .required,
        .references("securities", "id", onDelete: .cascade))
      .field("userID", .uuid, .required,
        .references("users", "id", onDelete: .cascade))
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("security-user-pivot").delete()
  }
}
