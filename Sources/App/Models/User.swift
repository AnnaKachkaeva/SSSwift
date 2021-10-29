import Fluent
import Vapor

final class User: Model, Content {
  static let schema = "users"

  @ID
  var id: UUID?
   
  @Field(key: "name")
  var name: String
   
  @Field(key: "age")
  var age: Int
    
  init() {}
    
  init(id: UUID? = nil, name: String, age: Int) {
    self.name = name
    self.age = age
  }
}
