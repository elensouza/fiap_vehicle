import Foundation

extension Components.Schemas.PaymentStatusPayload {
    func toEntity() throws -> Payment {
        guard let paymentId = UUID(uuidString: self.paymentId) else {
            throw PaymentError.repositoryFailure("PaymentId invalid")
        }
        guard let vehicleId = UUID(uuidString: self.vehicleId) else {
            throw PaymentError.repositoryFailure("VehicleId invalid")
        }

        guard let status = PaymentStatus(rawValue: self.status.rawValue) else {
            throw PaymentError.invalidStatus
        }

        return Payment(
            paymentId: paymentId,
            vehicleId: vehicleId,
            status: status,
            receivedAt: self.receivedAt
        )
    }
}
