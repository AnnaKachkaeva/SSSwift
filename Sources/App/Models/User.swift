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
    
    @Siblings(through: SecurityUserPivot.self,
              from: \.$user,
              to: \.$security)//связь в таблицах
    //@Field(key: "securities")
    var securities: [Security]
    
    init() {}
    
    init(id: UUID? = nil, name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
