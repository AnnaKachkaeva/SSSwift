import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    
    let securityController = SecuritiesController()
    try app.register(collection: securityController)
    
    let usersController = UsersController()
    try app.register(collection: usersController)

}
