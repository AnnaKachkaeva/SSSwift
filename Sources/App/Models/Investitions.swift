import Vapor
import Fluent
import Foundation


final class Security : Model {

    static var schema: String = "securities"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "tiker")
    var tiker : String
    
    @Field(key: "type")
    var type : String
    
    @Field(key: "price")
    var price : Float
    
    @Siblings(through: SecurityUserPivot.self,
              from: \.$security,
              to: \.$user)//связь в таблицах
    var users: [User]
    
    init(){}
    
    init(id: UUID? = nil, tiker: String, type: String, price: Float) {
        self.id = id
        self.tiker = tiker
        self.type = type
        self.price = price
    }
}

extension Security: Content {
    
}

