import Foundation

extension Components.Schemas.PaymentStatusPayload {
    func toEntity() throws -> Payment {
        guard let uuid = UUID(uuidString: paymentId) else {
            throw PaymentError.badRequest("Invalid UUID")
        }

        guard let status = PaymentStatus(rawValue: status.rawValue) else {
            throw PaymentError.invalidStatus
        }

        return Payment(paymentId: uuid, status: status, receivedAt: .now)
    }
}
