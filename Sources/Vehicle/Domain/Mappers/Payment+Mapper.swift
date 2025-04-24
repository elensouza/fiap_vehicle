import Foundation

extension Components.Schemas.PaymentStatusPayload {
    func toEntity() throws -> Payment {
        guard let id = UUID(uuidString: self.paymentId) else {
            throw PaymentError.repositoryFailure("Invalid UUID format")
        }

        guard let status = PaymentStatus(rawValue: self.status.rawValue) else {
            throw PaymentError.invalidStatus
        }

        return Payment(
            paymentId: id,
            status: status,
            receivedAt: self.receivedAt
        )
    }
}
