import OpenAPIRuntime
import OpenAPIVapor
import Fluent
import Vapor
import FluentKit

func routes(_ app: Application) throws {
    let transport = VaporTransport(routesBuilder: app)
    let repository = VehicleRepositoryFluent(db: app.db, logger: app.logger)
    let handler = VehicleHandler(repository: repository)

    try handler.registerHandlers(
        on: transport,
        serverURL: URL(string: "/api")! // TODO: Remove force unwrap
    )

    // Redirect `GET /swagger` to `GET /swagger.html`, for convenience.
    app.get("swagger") { req in
        req.redirect(to: "swagger.html", redirectType: .permanent)
    }
}
