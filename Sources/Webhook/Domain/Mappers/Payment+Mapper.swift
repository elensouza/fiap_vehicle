import Foundation

extension Components.Schemas.PaymentStatusPayload {
    func toEntity() throws -> Payment {
        guard let vehicleId = UUID(uuidString: vehicleId) else {
            throw PaymentError.badRequest("Invalid UUID")
        }

        let paymentId: UUID = UUID()

        guard let status = PaymentStatus(rawValue: status.rawValue) else {
            throw PaymentError.invalidStatus
        }

        return Payment(paymentId: paymentId, vehicleId: vehicleId, status: status, receivedAt: .now)
    }
}
