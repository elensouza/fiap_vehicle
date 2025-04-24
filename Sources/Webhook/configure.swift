import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory, cachePolicy: .noCache))

    app.http.server.configuration.port = Environment.get("WEBHOOK_SERVICE_PORT").flatMap(Int.init(_:)) ?? 9090

    // register routes
    try routes(app)
}
