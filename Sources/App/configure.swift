import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "nikitasergeevich",
        password: Environment.get("DATABASE_PASSWORD") ?? "16710985",
        database: Environment.get("DATABASE_NAME") ?? "beaumdb"
    ), as: .psql)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateAd())
    app.migrations.add(CreateRecord())
    app.migrations.add(CreateLike())

//    app.views.use(.leaf)

    
    try app.autoMigrate().wait()
    // register routes
    try routes(app)
}
