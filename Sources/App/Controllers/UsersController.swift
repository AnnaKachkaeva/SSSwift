import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAll)
        usersRoute.get(":userID", use: getUserByID)
        usersRoute.post(":userID", "act", ":secutityID", use: addSecurity)
        usersRoute.get(":userID", "securities", use: getUserSecuriries)
        usersRoute.delete(":userID", "act", ":secutityID", use: removeSecurity)
    }
    
    
    func createHandler(_ req: Request)
        throws -> EventLoopFuture<User> {
            let user = try req.content.decode(User.self)
            return user.save(on: req.db).map { user }
        }
    
    func getAll(_ req: Request) -> EventLoopFuture<[User]> {        
        return User.query(on: req.db).all()
    }
    
    func getUserByID(_ req: Request) -> EventLoopFuture<User> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func addSecurity(_ req: Request) -> EventLoopFuture<HTTPStatus> {//добавить новую акцию
    // FIXME: add check for duplicate records
        let userQuery = User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
        let sequrityQuery = Security.find(req.parameters.get("secutityID"), on: req.db).unwrap(or: Abort(.notFound))
        
        return userQuery.and(sequrityQuery).flatMap { user, security in
            user.$securities.attach(security, on: req.db).transform(to: .created)
        }
    }
    
    func removeSecurity(_ req: Request) -> EventLoopFuture<HTTPStatus> {//deletes all securities
        let userQuery = User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
        let sequrityQuery = Security.find(req.parameters.get("secutityID"), on: req.db).unwrap(or: Abort(.notFound))
        
        return userQuery.and(sequrityQuery).flatMap { user, security  in
            user.$securities.detach(security, on: req.db).transform(to: .noContent)
        }
    }

    
    func getUserSecuriries(_ req: Request) -> EventLoopFuture<[Security]> {
        User.find(req.parameters.get("userID"), on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { user in
              user.$securities.query(on: req.db).all()
        }
    }
}
