import OpenAPIRuntime
import OpenAPIVapor
import Vapor

func routes(_ app: Application) throws {
    let transport = VaporTransport(routesBuilder: app)
    let repository = PaymentRepositoryHTTP(client: app.client, logger: app.logger)
    let handler = WebhookHandler(repository: repository)

    guard let url = URL(string: "/api") else { fatalError("Failed to create an URL with the string '/api'.") }

    try handler.registerHandlers(
        on: transport,
        serverURL: url
    )

    // Redirect `GET /swagger` to `GET /webhook/swagger.html`, for convenience.
    app.get("swagger") { req in
        req.redirect(to: "webhook/swagger.html", redirectType: .permanent)
    }
}
