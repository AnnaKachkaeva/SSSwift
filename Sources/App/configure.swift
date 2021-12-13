import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {

    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    //app.logger.logLevel = .debug//-shows every action of fluent
    app.migrations.add(CreateEquity())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateSecurityUserPivot())
    
    //try app.autoRevert().wait()//-clear db table
    
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
