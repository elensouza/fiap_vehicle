import Foundation

struct Payment {
    let paymentId: UUID
    let vehicleId: UUID
    let status: PaymentStatus
    let receivedAt: Date
}

enum PaymentStatus: String {
    case paid = "PAID"
    case cancelled = "CANCELLED"
}
