import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAll)
        usersRoute.get(":userID", use: getUserByID)
    }
    
    
    func createHandler(_ req: Request)
        throws -> EventLoopFuture<User> {
            let user = try req.content.decode(User.self)
            return user.save(on: req.db).map { user }
        }
    
    func getAll(_ req: Request) -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    
    func getUserByID(_ req: Request) -> EventLoopFuture<User> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
    }
}
