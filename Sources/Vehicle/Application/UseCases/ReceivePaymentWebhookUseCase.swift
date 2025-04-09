import Foundation

struct ReceivePaymentWebhookUseCase: @unchecked Sendable {
    func execute() async throws {
        // Aqui você pode processar o payload ou logar
        print("Pagamento recebido")
    }
}
