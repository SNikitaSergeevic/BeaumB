import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in "http://127.0.0.1:8080/"}

    try app.register(collection: UserController())
    try app.register(collection: AdController())
    try app.register(collection: RecordController())
    try app.register(collection: LikeController())
}
