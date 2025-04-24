import Foundation
import Vapor

struct PaymentRepositoryHTTP: PaymentRepository {
    private let client: any Client
    private let logger: Logger

    init(client: any Client, logger: Logger) {
        self.client = client
        self.logger = logger
    }

    func registerPaymentStatus(_ payment: Payment) async throws {
        try await perform {
            let hostname = Environment.get("VEHICLE_SERVICE_HOST") ?? "localhost"
            let port = Environment.get("VEHICLE_SERVICE_PORT").flatMap(Int.init(_:)) ?? 8080
            let url = URI(string: "http://\(hostname):\(port)/api/vehicles/payment-status")

            struct Payload: Content {
                let paymentId: UUID
                let status: String
                let receivedAt: Date
            }

            let body = Payload(
                paymentId: payment.paymentId,
                status: payment.status.rawValue,
                receivedAt: payment.receivedAt
            )

            let response = try await client.post(url) { req in
                try req.content.encode(body)
            }

            guard response.status != .ok else { return }

            let errorResponse = try response.content.decode(ErrorResponse.self)

            switch response.status {
            case .notFound:
                throw PaymentError.notFound(errorResponse.message)
            case .badRequest:
                throw PaymentError.badRequest(errorResponse.message)
            case .conflict:
                throw PaymentError.conflict(errorResponse.message)
            case .internalServerError:
                fallthrough
            default:
                throw PaymentError.internalServerError(errorResponse.message)
            }
        }
    }
}

private extension PaymentRepositoryHTTP {
    func perform<T>(_ operation: () async throws -> T) async throws -> T {
        do {
            return try await operation()
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
}
