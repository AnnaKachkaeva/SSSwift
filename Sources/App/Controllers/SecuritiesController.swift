import Vapor
import Fluent

struct SecuritiesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let securityRoutes = routes.grouped("api", "act")
        securityRoutes.get(use: getAllHandler)
        securityRoutes.post(use: addNewSecurity)
        securityRoutes.get(":securityID", use: getByID)
        securityRoutes.put(":securityID", use: updateByID)
        securityRoutes.delete(":securityID", use: deleteByID)
        securityRoutes.get("search", use: searchByTiker)
        securityRoutes.get("sorted", use: sortByPrice)
    }
        
        
    func addNewSecurity(_ req: Request) throws -> EventLoopFuture<Security> {
        let security = try req.content.decode(Security.self)
        return security.save(on: req.db).map{ security }
    }
        
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Security]> {
        Security.query(on: req.db).all()
    }
        
    func getByID(_ req: Request) -> EventLoopFuture<Security> {
        Security.find(req.parameters.get("securityID"), on: req.db).unwrap(or: Abort(.notFound))
    }

    func updateByID(_ req: Request) throws -> EventLoopFuture<Security> {
        let sec = try req.content.decode(Security.self)

        return Security.find( req.parameters.get("securityID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { security in
                security.tiker = sec.tiker
                security.price = sec.price
                security.type = sec.type
            return security.save(on: req.db).map {
                security
            }
        }
    }
        
    func deleteByID(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        Security.find(req.parameters.get("securityID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { security in
                security.delete(on: req.db)
                .transform(to: .noContent)
            }
    }
        
    func searchByTiker(_ req: Request) throws -> EventLoopFuture<[Security]> {
        guard let searchTerm = req.query[String.self, at: "tiker"] else {
            throw Abort(.badRequest)
        }
            return Security.query(on: req.db).filter(\.$tiker == searchTerm).all()
    }
        
    func sortByPrice(_ req: Request) -> EventLoopFuture<[Security]> {
        Security.query(on: req.db).sort(\.$price, .ascending).all()
    }
        
}



