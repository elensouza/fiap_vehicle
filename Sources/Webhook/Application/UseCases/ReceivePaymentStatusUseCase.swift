import Foundation

struct ReceivePaymentStatusUseCase: @unchecked Sendable {
    private let repository: any PaymentRepository

    init(repository: any PaymentRepository) {
        self.repository = repository
    }

    func execute(payload: Payment) async throws {
        guard [.paid, .cancelled].contains(payload.status) else {
            throw PaymentError.invalidStatus
        }

        try await repository.registerPaymentStatus(payload)
    }
}
