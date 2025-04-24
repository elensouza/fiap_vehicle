import Foundation

struct Payment {
    let paymentId: UUID
    let status: PaymentStatus
    let receivedAt: Date
}
