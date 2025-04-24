import Foundation

protocol PaymentRepository: Sendable {
    func registerPaymentStatus(_ payment: Payment) async throws
}
