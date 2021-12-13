import Fluent
import Foundation

final class SecurityUserPivot: Model {
  static let schema = "security-user-pivot"
  
  @ID
  var id: UUID?
  
  @Parent(key: "securityID")
  var security: Security
  
  @Parent(key: "userID")
  var user: User
  
  init() {}
  
  init(
    id: UUID? = nil,
    security: Security,
    user: User
  ) throws {
    self.id = id
    self.$security.id = try security.requireID()
    self.$user.id = try user.requireID()
  }
}
