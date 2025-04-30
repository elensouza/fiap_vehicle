import OpenAPIRuntime
import OpenAPIVapor
import Fluent
import Vapor
import FluentKit

func routes(_ app: Application) throws {
    let transport = VaporTransport(routesBuilder: app)
    let repository = VehicleRepositoryFluent(db: app.db, logger: app.logger)
    let handler = VehicleHandler(repository: repository)

    guard let url = URL(string: "/api") else { fatalError("Failed to create an URL with the string '/api'.") }

    try handler.registerHandlers(
        on: transport,
        serverURL: url
    )

    // Redirect `GET /swagger` to `GET /vehicle/swagger.html`, for convenience.
    app.get("swagger") { req in
        req.redirect(to: "vehicle/swagger.html", redirectType: .permanent)
    }
}
